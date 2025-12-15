package com.ourride.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class VerifyOtpRequest {
    
    @NotBlank(message = "Phone number is required")
    @Pattern(regexp = "^[0-9]{10,15}$", message = "Invalid phone number format")
    private String phoneNumber;
    
    @NotBlank(message = "Country code is required")
    @Pattern(regexp = "^\\+[0-9]{1,4}$", message = "Invalid country code format")
    private String countryCode;
    
    @NotBlank(message = "OTP is required")
    @Pattern(regexp = "^[0-9]{4}$", message = "OTP must be 4 digits")
    private String otp;
    
    // Deprecated: No longer used - sign-up/sign-in is automatically determined by user existence
    @Deprecated
    private boolean isSignUp = false;
}

