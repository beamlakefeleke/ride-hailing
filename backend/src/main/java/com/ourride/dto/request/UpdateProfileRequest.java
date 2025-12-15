package com.ourride.dto.request;

import jakarta.validation.constraints.Email;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateProfileRequest {
    
    private String fullName;
    
    @Email(message = "Invalid email format")
    private String email;
    
    private String phoneNumber;
    
    private String countryCode;
    
    private String gender; // MALE, FEMALE, OTHER, PREFER_NOT_TO_SAY
    
    private LocalDate dateOfBirth;
    
    private String profileImageUrl;
}

