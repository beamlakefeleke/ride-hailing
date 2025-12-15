package com.ourride.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "drivers", indexes = {
    @Index(name = "idx_drivers_user_id", columnList = "userId"),
    @Index(name = "idx_drivers_available", columnList = "isAvailable")
})
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Driver {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "user_id", nullable = false, unique = true)
    private Long userId;
    
    @Column(name = "vehicle_type", nullable = false, length = 50)
    private String vehicleType;
    
    @Column(name = "vehicle_number", nullable = false, length = 20)
    private String vehicleNumber;
    
    @Column(name = "license_number", nullable = false, unique = true, length = 50)
    private String licenseNumber;
    
    @Column(nullable = false, precision = 3, scale = 2)
    @Builder.Default
    private BigDecimal rating = BigDecimal.ZERO;
    
    @Column(name = "total_rides", nullable = false)
    @Builder.Default
    private Integer totalRides = 0;
    
    @Column(name = "is_available", nullable = false)
    @Builder.Default
    private Boolean isAvailable = true;
    
    @Column(name = "current_latitude", precision = 10, scale = 8)
    private BigDecimal currentLatitude;
    
    @Column(name = "current_longitude", precision = 11, scale = 8)
    private BigDecimal currentLongitude;
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}

