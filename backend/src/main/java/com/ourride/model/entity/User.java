package com.ourride.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "users", indexes = {
    @Index(name = "idx_phone", columnList = "phoneNumber"),
    @Index(name = "idx_email", columnList = "email")
})
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = true, unique = true, length = 20)
    private String phoneNumber; // Full phone with country code: +11234567890
    
    @Column(unique = true, length = 100)
    private String email;
    
    @Column(length = 100)
    private String fullName;
    
    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private Gender gender;
    
    private LocalDate dateOfBirth;
    
    @Column(length = 500)
    private String profileImageUrl;
    
    @Column(nullable = false)
    private String password; // Encrypted password (for social login users)
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private AuthProvider authProvider; // PHONE, GOOGLE, APPLE, FACEBOOK, X
    
    @Column(length = 200)
    private String providerId; // Provider's user ID for social login
    
    @Column(nullable = false)
    private boolean emailVerified = false;
    
    @Column(nullable = false)
    private boolean phoneVerified = false;
    
    @Column(nullable = false)
    private boolean profileCompleted = false;
    
    @Column(nullable = false)
    private boolean active = true;
    
    @Column(nullable = false)
    private boolean rememberMe = false;
    
    @Builder.Default
    @Column(nullable = false, precision = 10, scale = 2)
    private java.math.BigDecimal walletBalance = java.math.BigDecimal.ZERO;
    
    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(nullable = false)
    private LocalDateTime updatedAt;
    
    public enum Gender {
        MALE, FEMALE, OTHER, PREFER_NOT_TO_SAY
    }
    
    public enum AuthProvider {
        PHONE, GOOGLE, APPLE, FACEBOOK, X
    }
}

