package com.ourride.service;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Random;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
@Slf4j
public class OtpService {
    
    private final RedisTemplate<String, String> redisTemplate;
    
    @Value("${twilio.account-sid:}")
    private String accountSid;
    
    @Value("${twilio.auth-token:}")
    private String authToken;
    
    @Value("${twilio.phone-number:}")
    private String twilioPhoneNumber;
    
    @Value("${otp.expiration-seconds:300}") // 5 minutes default
    private int otpExpirationSeconds;
    
    @Value("${otp.resend-cooldown-seconds:60}") // 60 seconds default
    private int resendCooldownSeconds;
    
    /**
     * Generate and send OTP to phone number
     */
    public String generateAndSendOtp(String phoneNumber, String countryCode) {
        // Generate 4-digit OTP
        String otp = generateOtp();
        
        // Store in Redis with expiration
        String key = getOtpKey(phoneNumber, countryCode);
        redisTemplate.opsForValue().set(key, otp, otpExpirationSeconds, TimeUnit.SECONDS);
        
        // Store resend cooldown
        String cooldownKey = getCooldownKey(phoneNumber, countryCode);
        redisTemplate.opsForValue().set(
            cooldownKey, 
            "1", 
            resendCooldownSeconds, 
            TimeUnit.SECONDS
        );
        
        // Send SMS via Twilio (if configured)
        if (isTwilioConfigured()) {
            sendSms(phoneNumber, countryCode, otp);
        } else {
            // In development, log OTP instead
            log.info("OTP for {} {}: {}", countryCode, phoneNumber, otp);
        }
        
        return otp;
    }
    
    /**
     * Verify OTP
     */
    public boolean verifyOtp(String phoneNumber, String countryCode, String otp) {
        String key = getOtpKey(phoneNumber, countryCode);
        String storedOtp = redisTemplate.opsForValue().get(key);
        
        if (storedOtp == null) {
            log.warn("OTP not found or expired for {} {}", countryCode, phoneNumber);
            return false; // OTP expired or doesn't exist
        }
        
        boolean isValid = storedOtp.equals(otp);
        
        if (isValid) {
            // Delete OTP after successful verification
            redisTemplate.delete(key);
            log.info("OTP verified successfully for {} {}", countryCode, phoneNumber);
        } else {
            log.warn("Invalid OTP attempt for {} {}", countryCode, phoneNumber);
        }
        
        return isValid;
    }
    
    /**
     * Check if OTP can be resent (cooldown period passed)
     */
    public boolean canResendOtp(String phoneNumber, String countryCode) {
        String cooldownKey = getCooldownKey(phoneNumber, countryCode);
        String cooldown = redisTemplate.opsForValue().get(cooldownKey);
        return cooldown == null; // No cooldown means can resend
    }
    
    /**
     * Get remaining cooldown time in seconds
     */
    public long getRemainingCooldown(String phoneNumber, String countryCode) {
        String cooldownKey = getCooldownKey(phoneNumber, countryCode);
        Long ttl = redisTemplate.getExpire(cooldownKey, TimeUnit.SECONDS);
        return ttl != null && ttl > 0 ? ttl : 0;
    }
    
    /**
     * Generate 4-digit OTP
     */
    private String generateOtp() {
        Random random = new Random();
        int otp = 1000 + random.nextInt(9000); // 4-digit OTP (1000-9999)
        return String.valueOf(otp);
    }
    
    /**
     * Send SMS via Twilio
     */
    private void sendSms(String phoneNumber, String countryCode, String otp) {
        try {
            Twilio.init(accountSid, authToken);
            
            String fullPhoneNumber = countryCode + phoneNumber;
            String messageBody = "Your OurRide verification code is: " + otp + ". Valid for 5 minutes.";
            
            Message message = Message.creator(
                new PhoneNumber(fullPhoneNumber),
                new PhoneNumber(twilioPhoneNumber),
                messageBody
            ).create();
            
            log.info("OTP SMS sent to {}: Message SID: {}", fullPhoneNumber, message.getSid());
            
        } catch (Exception e) {
            log.error("Failed to send OTP SMS to {} {}: {}", countryCode, phoneNumber, e.getMessage());
            // Don't throw exception - OTP is still stored in Redis
        }
    }
    
    /**
     * Check if Twilio is configured
     */
    private boolean isTwilioConfigured() {
        return accountSid != null && !accountSid.isEmpty() &&
               authToken != null && !authToken.isEmpty() &&
               twilioPhoneNumber != null && !twilioPhoneNumber.isEmpty();
    }
    
    /**
     * Get Redis key for OTP
     */
    private String getOtpKey(String phoneNumber, String countryCode) {
        return "otp:" + countryCode + ":" + phoneNumber;
    }
    
    /**
     * Get Redis key for resend cooldown
     */
    private String getCooldownKey(String phoneNumber, String countryCode) {
        return "otp:cooldown:" + countryCode + ":" + phoneNumber;
    }
}

