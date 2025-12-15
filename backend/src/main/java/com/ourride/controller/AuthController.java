package com.ourride.controller;

import com.ourride.dto.request.PhoneOtpRequest;
import com.ourride.dto.request.ProfileCompletionRequest;
import com.ourride.dto.request.SocialLoginRequest;
import com.ourride.dto.request.UpdateProfileRequest;
import com.ourride.dto.request.VerifyOtpRequest;
import com.ourride.dto.response.AuthResponse;
import com.ourride.dto.response.OtpResponse;
import com.ourride.dto.response.UserProfileResponse;
import com.ourride.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    
    private final AuthService authService;
    
    /**
     * Send OTP to phone number
     * POST /api/auth/send-otp
     */
    @PostMapping("/send-otp")
    public ResponseEntity<OtpResponse> sendOtp(@Valid @RequestBody PhoneOtpRequest request) {
        OtpResponse response = authService.sendOtp(request);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Resend OTP
     * POST /api/auth/resend-otp
     */
    @PostMapping("/resend-otp")
    public ResponseEntity<OtpResponse> resendOtp(@Valid @RequestBody PhoneOtpRequest request) {
        OtpResponse response = authService.resendOtp(request);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Verify OTP and authenticate
     * POST /api/auth/verify-otp
     */
    @PostMapping("/verify-otp")
    public ResponseEntity<AuthResponse> verifyOtp(@Valid @RequestBody VerifyOtpRequest request) {
        AuthResponse response = authService.verifyOtp(request);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Social login (Google, Apple, Facebook, X)
     * POST /api/auth/social-login
     */
    @PostMapping("/social-login")
    public ResponseEntity<AuthResponse> socialLogin(@Valid @RequestBody SocialLoginRequest request) {
        AuthResponse response = authService.socialLogin(request);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Complete user profile (after sign-up)
     * POST /api/auth/complete-profile
     * Requires: Authorization header with Bearer token
     */
    @PostMapping("/complete-profile")
    public ResponseEntity<AuthResponse> completeProfile(
        @Valid @RequestBody ProfileCompletionRequest request,
        Authentication authentication
    ) {
        if (authentication == null || authentication.getName() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .build();
        }
        
        Long userId = Long.parseLong(authentication.getName());
        AuthResponse response = authService.completeProfile(userId, request);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Refresh access token
     * POST /api/auth/refresh-token
     * Requires: Authorization header with Bearer refresh_token
     */
    @PostMapping("/refresh-token")
    public ResponseEntity<?> refreshToken(@RequestHeader(value = "Authorization", required = false) String authHeader) {
        if (authHeader == null || authHeader.isBlank() || !authHeader.startsWith("Bearer ")) {
            Map<String, Object> errorResponse = Map.of(
                "success", false,
                "message", "Authorization header with Bearer token is required"
            );
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
        }
        
        String refreshToken = authHeader.substring(7).trim();
        if (refreshToken.isEmpty()) {
            Map<String, Object> errorResponse = Map.of(
                "success", false,
                "message", "Refresh token is required"
            );
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
        }
        
        try {
            AuthResponse response = authService.refreshToken(refreshToken);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            Map<String, Object> errorResponse = Map.of(
                "success", false,
                "message", e.getMessage()
            );
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
        }
    }
    
    /**
     * Check if phone number exists
     * GET /api/auth/check-phone?phoneNumber=...&countryCode=...
     * Note: Use %2B for + sign in URL (e.g., countryCode=%2B1)
     */
    @GetMapping("/check-phone")
    public ResponseEntity<Map<String, Object>> checkPhone(
        @RequestParam String phoneNumber,
        @RequestParam String countryCode
    ) {
        // Normalize country code: replace spaces with + (handles URL encoding issue where + becomes space)
        String normalizedCountryCode = countryCode.trim().replace(" ", "+");
        // Ensure country code starts with +
        if (!normalizedCountryCode.startsWith("+")) {
            normalizedCountryCode = "+" + normalizedCountryCode;
        }
        
        String fullPhoneNumber = normalizedCountryCode + phoneNumber;
        boolean exists = authService.userExists(fullPhoneNumber);
        
        return ResponseEntity.ok(Map.of(
            "exists", exists,
            "message", exists ? "Phone number already registered" : "Phone number available",
            "searchedPhoneNumber", fullPhoneNumber // Debug info
        ));
    }
    
    /**
     * Get current user profile
     * GET /api/auth/profile
     * Requires: Authorization header with Bearer token
     */
    @GetMapping("/profile")
    public ResponseEntity<UserProfileResponse> getProfile(Authentication authentication) {
        if (authentication == null || authentication.getName() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        Long userId = Long.parseLong(authentication.getName());
        UserProfileResponse response = authService.getUserProfile(userId);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Logout (client-side token clearing)
     * POST /api/auth/logout
     * Note: In JWT-based auth, logout is typically handled client-side by clearing tokens
     * This endpoint can be used for server-side token blacklisting if needed
     */
    @PostMapping("/logout")
    public ResponseEntity<Map<String, String>> logout(Authentication authentication) {
        // In JWT-based auth, logout is typically client-side
        // This endpoint can be used for logging/logging out activity
        return ResponseEntity.ok(Map.of("message", "Logged out successfully"));
    }
    
    /**
     * Update user profile
     * PUT /api/auth/profile
     * Requires: Authorization header with Bearer token
     */
    @PutMapping("/profile")
    public ResponseEntity<UserProfileResponse> updateProfile(
        @Valid @RequestBody UpdateProfileRequest request,
        Authentication authentication
    ) {
        if (authentication == null || authentication.getName() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        Long userId = Long.parseLong(authentication.getName());
        UserProfileResponse response = authService.updateProfile(userId, request);
        return ResponseEntity.ok(response);
    }
}

