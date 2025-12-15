package com.ourride.service;

import com.ourride.dto.request.PhoneOtpRequest;
import com.ourride.dto.request.ProfileCompletionRequest;
import com.ourride.dto.request.SocialLoginRequest;
import com.ourride.dto.request.UpdateProfileRequest;
import com.ourride.dto.request.VerifyOtpRequest;
import com.ourride.dto.response.AuthResponse;
import com.ourride.dto.response.OtpResponse;
import com.ourride.dto.response.UserProfileResponse;
import com.ourride.model.entity.User;
import com.ourride.repository.UserRepository;
import com.ourride.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {
    
    private final UserRepository userRepository;
    private final OtpService otpService;
    private final JwtTokenProvider jwtTokenProvider;
    private final PasswordEncoder passwordEncoder;
    
    /**
     * Send OTP for phone number verification
     */
    public OtpResponse sendOtp(PhoneOtpRequest request) {
        String fullPhoneNumber = request.getCountryCode() + request.getPhoneNumber();
        
        // Generate and send OTP
        otpService.generateAndSendOtp(request.getPhoneNumber(), request.getCountryCode());
        
        long remainingCooldown = otpService.getRemainingCooldown(
            request.getPhoneNumber(), 
            request.getCountryCode()
        );
        
        return OtpResponse.builder()
            .message("OTP sent successfully")
            .expiresIn(300) // 5 minutes
            .canResend(remainingCooldown == 0)
            .build();
    }
    
    /**
     * Resend OTP
     */
    public OtpResponse resendOtp(PhoneOtpRequest request) {
        // Check if can resend
        if (!otpService.canResendOtp(request.getPhoneNumber(), request.getCountryCode())) {
            long remaining = otpService.getRemainingCooldown(
                request.getPhoneNumber(), 
                request.getCountryCode()
            );
            throw new RuntimeException("Please wait " + remaining + " seconds before resending OTP");
        }
        
        // Generate and send new OTP
        otpService.generateAndSendOtp(request.getPhoneNumber(), request.getCountryCode());
        
        return OtpResponse.builder()
            .message("OTP resent successfully")
            .expiresIn(300)
            .canResend(false)
            .build();
    }
    
    /**
     * Verify OTP and authenticate user
     * Automatically handles both sign-up and sign-in based on user existence
     */
    @Transactional
    public AuthResponse verifyOtp(VerifyOtpRequest request) {
        // Verify OTP
        boolean isValid = otpService.verifyOtp(
            request.getPhoneNumber(),
            request.getCountryCode(),
            request.getOtp()
        );
        
        if (!isValid) {
            throw new RuntimeException("Invalid or expired OTP");
        }
        
        String fullPhoneNumber = request.getCountryCode() + request.getPhoneNumber();
        
        // Check if user exists - automatically determine sign-up vs sign-in
        Optional<User> existingUser = userRepository.findByPhoneNumber(fullPhoneNumber);
        
        if (existingUser.isPresent()) {
            // Sign In Flow - User exists
            User user = existingUser.get();
            log.info("OTP verification - existing user sign in: {}", user.getId());
            
            // Update phone verification status
            if (!user.isPhoneVerified()) {
                user.setPhoneVerified(true);
                userRepository.save(user);
            }
            
            // Generate tokens
            String accessToken = jwtTokenProvider.generateToken(user.getId().toString());
            String refreshToken = jwtTokenProvider.generateRefreshToken(user.getId().toString());
            
            return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .expiresIn(86400L) // 24 hours
                .user(AuthResponse.UserInfo.builder()
                    .id(user.getId())
                    .phoneNumber(user.getPhoneNumber())
                    .email(user.getEmail())
                    .fullName(user.getFullName())
                    .phoneVerified(user.isPhoneVerified())
                    .emailVerified(user.isEmailVerified())
                    .build())
                .profileCompleted(user.isProfileCompleted())
                .requiresProfileCompletion(!user.isProfileCompleted())
                .build();
            
        } else {
            // Sign Up Flow - User doesn't exist, create new user
            User newUser = User.builder()
                .phoneNumber(fullPhoneNumber)
                .phoneVerified(true)
                .authProvider(User.AuthProvider.PHONE)
                .password(passwordEncoder.encode("")) // Empty password for phone auth
                .profileCompleted(false)
                .active(true)
                .walletBalance(java.math.BigDecimal.ZERO)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
            
            newUser = userRepository.save(newUser);
            log.info("OTP verification - new user created: {}", newUser.getId());
            
            // Generate tokens
            String accessToken = jwtTokenProvider.generateToken(newUser.getId().toString());
            String refreshToken = jwtTokenProvider.generateRefreshToken(newUser.getId().toString());
            
            return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .expiresIn(86400L) // 24 hours
                .user(AuthResponse.UserInfo.builder()
                    .id(newUser.getId())
                    .phoneNumber(newUser.getPhoneNumber())
                    .phoneVerified(newUser.isPhoneVerified())
                    .build())
                .profileCompleted(false)
                .requiresProfileCompletion(true)
                .build();
        }
    }
    
    /**
     * Social login (Google, Apple, Facebook, X)
     */
    @Transactional
    public AuthResponse socialLogin(SocialLoginRequest request) {
        // Verify social token (implementation depends on provider)
        // For now, we'll trust the provider ID
        
        // Check if user exists with this provider
        Optional<User> existingUser = userRepository.findByProviderIdAndAuthProvider(
            request.getProviderId(),
            request.getProvider()
        );
        
        User user;
        
        if (existingUser.isPresent()) {
            // Existing user - sign in
            user = existingUser.get();
            log.info("Social login - existing user: {}", user.getId());
        } else {
            // New user - sign up
            user = User.builder()
                .authProvider(request.getProvider())
                .providerId(request.getProviderId())
                .email(request.getEmail())
                .fullName(request.getFullName())
                .profileImageUrl(request.getProfileImageUrl())
                .emailVerified(request.getEmail() != null && !request.getEmail().isEmpty())
                .phoneVerified(false)
                .password(passwordEncoder.encode("")) // Empty for social login
                .profileCompleted(request.getFullName() != null && !request.getFullName().isEmpty())
                .active(true)
                .walletBalance(java.math.BigDecimal.ZERO)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
            
            user = userRepository.save(user);
            log.info("Social login - new user created: {}", user.getId());
        }
        
        // Generate tokens
        String accessToken = jwtTokenProvider.generateToken(user.getId().toString());
        String refreshToken = jwtTokenProvider.generateRefreshToken(user.getId().toString());
        
        return AuthResponse.builder()
            .accessToken(accessToken)
            .refreshToken(refreshToken)
            .expiresIn(86400L) // 24 hours
            .user(AuthResponse.UserInfo.builder()
                .id(user.getId())
                .phoneNumber(user.getPhoneNumber())
                .email(user.getEmail())
                .fullName(user.getFullName())
                .phoneVerified(user.isPhoneVerified())
                .emailVerified(user.isEmailVerified())
                .build())
            .profileCompleted(user.isProfileCompleted())
            .requiresProfileCompletion(!user.isProfileCompleted())
            .build();
    }
    
    /**
     * Complete user profile after sign-up
     */
    @Transactional
    public AuthResponse completeProfile(Long userId, ProfileCompletionRequest request) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        // Update user profile
        user.setFullName(request.getFullName());
        user.setEmail(request.getEmail());
        user.setGender(request.getGender());
        user.setDateOfBirth(request.getDateOfBirth());
        user.setEmailVerified(false); // Email needs separate verification
        user.setProfileCompleted(true);
        user.setUpdatedAt(LocalDateTime.now());
        
        // Update phone number if different
        String fullPhoneNumber = request.getCountryCode() + request.getPhoneNumber();
        if (!fullPhoneNumber.equals(user.getPhoneNumber())) {
            // Check if new phone number is already taken
            if (userRepository.findByPhoneNumber(fullPhoneNumber).isPresent()) {
                throw new RuntimeException("Phone number already registered");
            }
            user.setPhoneNumber(fullPhoneNumber);
        }
        
        user = userRepository.save(user);
        
        // Generate new tokens
        String accessToken = jwtTokenProvider.generateToken(user.getId().toString());
        String refreshToken = jwtTokenProvider.generateRefreshToken(user.getId().toString());
        
        return AuthResponse.builder()
            .accessToken(accessToken)
            .refreshToken(refreshToken)
            .expiresIn(86400L)
            .user(AuthResponse.UserInfo.builder()
                .id(user.getId())
                .phoneNumber(user.getPhoneNumber())
                .email(user.getEmail())
                .fullName(user.getFullName())
                .phoneVerified(user.isPhoneVerified())
                .emailVerified(user.isEmailVerified())
                .build())
            .profileCompleted(true)
            .requiresProfileCompletion(false)
            .build();
    }
    
    /**
     * Refresh access token
     */
    public AuthResponse refreshToken(String refreshToken) {
        // Validate that the token is a valid refresh token
        if (!jwtTokenProvider.validateRefreshToken(refreshToken)) {
            throw new RuntimeException("Invalid or expired refresh token");
        }
        
        // Extract user ID from refresh token
        String userId;
        try {
            userId = jwtTokenProvider.getUserIdFromToken(refreshToken);
        } catch (Exception e) {
            log.error("Failed to extract user ID from refresh token: {}", e.getMessage());
            throw new RuntimeException("Invalid refresh token");
        }
        
        // Find user
        User user = userRepository.findById(Long.parseLong(userId))
            .orElseThrow(() -> {
                log.error("User not found for ID: {}", userId);
                return new RuntimeException("User not found");
            });
        
        // Check if user is active
        if (!user.isActive()) {
            log.warn("Attempted refresh token for inactive user: {}", userId);
            throw new RuntimeException("User account is inactive");
        }
        
        log.info("Refreshing tokens for user: {}", userId);
        
        // Generate new tokens
        String newAccessToken = jwtTokenProvider.generateToken(userId);
        String newRefreshToken = jwtTokenProvider.generateRefreshToken(userId);
        
        return AuthResponse.builder()
            .accessToken(newAccessToken)
            .refreshToken(newRefreshToken)
            .expiresIn(86400L)
            .user(AuthResponse.UserInfo.builder()
                .id(user.getId())
                .phoneNumber(user.getPhoneNumber())
                .email(user.getEmail())
                .fullName(user.getFullName())
                .phoneVerified(user.isPhoneVerified())
                .emailVerified(user.isEmailVerified())
                .build())
            .profileCompleted(user.isProfileCompleted())
            .requiresProfileCompletion(!user.isProfileCompleted())
            .build();
    }
    
    /**
     * Check if user exists by phone number
     */
    public boolean userExists(String fullPhoneNumber) {
        log.debug("Checking if user exists with phone number: {}", fullPhoneNumber);
        boolean exists = userRepository.existsByPhoneNumber(fullPhoneNumber);
        log.debug("User exists check result for {}: {}", fullPhoneNumber, exists);
        return exists;
    }
    
    /**
     * Get user profile by user ID
     */
    @Transactional(readOnly = true)
    public UserProfileResponse getUserProfile(Long userId) {
        log.info("Getting profile for user: {}", userId);
        
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        return UserProfileResponse.builder()
            .id(user.getId())
            .phoneNumber(user.getPhoneNumber())
            .email(user.getEmail())
            .fullName(user.getFullName())
            .gender(user.getGender() != null ? user.getGender().name() : null)
            .dateOfBirth(user.getDateOfBirth())
            .profileImageUrl(user.getProfileImageUrl())
            .authProvider(user.getAuthProvider() != null ? user.getAuthProvider().name() : null)
            .emailVerified(user.isEmailVerified())
            .phoneVerified(user.isPhoneVerified())
            .profileCompleted(user.isProfileCompleted())
            .walletBalance(user.getWalletBalance())
            .createdAt(user.getCreatedAt())
            .updatedAt(user.getUpdatedAt())
            .build();
    }
    
    /**
     * Update user profile
     */
    @Transactional
    public UserProfileResponse updateProfile(Long userId, UpdateProfileRequest request) {
        log.info("Updating profile for user: {}", userId);
        
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        // Update fields if provided
        if (request.getFullName() != null && !request.getFullName().isEmpty()) {
            user.setFullName(request.getFullName());
        }
        
        if (request.getEmail() != null && !request.getEmail().isEmpty()) {
            // Check if email is already taken by another user
            userRepository.findByEmail(request.getEmail())
                .ifPresent(existingUser -> {
                    if (!existingUser.getId().equals(userId)) {
                        throw new RuntimeException("Email already registered");
                    }
                });
            user.setEmail(request.getEmail());
            user.setEmailVerified(false); // Require re-verification
        }
        
        if (request.getPhoneNumber() != null && request.getCountryCode() != null) {
            String fullPhoneNumber = request.getCountryCode() + request.getPhoneNumber();
            // Check if phone is already taken by another user
            userRepository.findByPhoneNumber(fullPhoneNumber)
                .ifPresent(existingUser -> {
                    if (!existingUser.getId().equals(userId)) {
                        throw new RuntimeException("Phone number already registered");
                    }
                });
            user.setPhoneNumber(fullPhoneNumber);
            user.setPhoneVerified(false); // Require re-verification
        }
        
        if (request.getGender() != null) {
            try {
                user.setGender(User.Gender.valueOf(request.getGender()));
            } catch (IllegalArgumentException e) {
                throw new RuntimeException("Invalid gender: " + request.getGender());
            }
        }
        
        if (request.getDateOfBirth() != null) {
            user.setDateOfBirth(request.getDateOfBirth());
        }
        
        if (request.getProfileImageUrl() != null) {
            user.setProfileImageUrl(request.getProfileImageUrl());
        }
        
        user = userRepository.save(user);
        log.info("Profile updated for user: {}", userId);
        
        return UserProfileResponse.builder()
            .id(user.getId())
            .phoneNumber(user.getPhoneNumber())
            .email(user.getEmail())
            .fullName(user.getFullName())
            .gender(user.getGender() != null ? user.getGender().name() : null)
            .dateOfBirth(user.getDateOfBirth())
            .profileImageUrl(user.getProfileImageUrl())
            .authProvider(user.getAuthProvider() != null ? user.getAuthProvider().name() : null)
            .emailVerified(user.isEmailVerified())
            .phoneVerified(user.isPhoneVerified())
            .profileCompleted(user.isProfileCompleted())
            .walletBalance(user.getWalletBalance())
            .createdAt(user.getCreatedAt())
            .updatedAt(user.getUpdatedAt())
            .build();
    }
}

