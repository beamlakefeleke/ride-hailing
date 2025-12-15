package com.ourride.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserProfileResponse {
    private Long id;
    private String phoneNumber;
    private String email;
    private String fullName;
    private String gender;
    private LocalDate dateOfBirth;
    private String profileImageUrl;
    private String authProvider;
    private boolean emailVerified;
    private boolean phoneVerified;
    private boolean profileCompleted;
    private BigDecimal walletBalance;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

