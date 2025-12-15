package com.ourride.dto.request;

import com.ourride.model.entity.User.AuthProvider;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SocialLoginRequest {
    
    @NotNull(message = "Auth provider is required")
    private AuthProvider provider; // GOOGLE, APPLE, FACEBOOK, X
    
    @NotBlank(message = "Provider ID is required")
    private String providerId; // User ID from the provider
    
    private String email;
    
    private String fullName;
    
    private String profileImageUrl;
    
    private String accessToken; // For verification
}

