package com.ourride.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RideResponse {
    
    private Long id;
    private Long userId;
    private Long driverId;
    private BigDecimal pickupLatitude;
    private BigDecimal pickupLongitude;
    private String pickupAddress;
    private BigDecimal destinationLatitude;
    private BigDecimal destinationLongitude;
    private String destinationAddress;
    private String rideType;
    private String status;
    private BigDecimal price;
    private BigDecimal distanceKm;
    private Integer estimatedDurationMinutes;
    private LocalDateTime scheduledDateTime;
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;
    private LocalDateTime cancelledAt;
    private String cancellationReason;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Driver information (if assigned)
    private DriverInfo driver;
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DriverInfo {
        private Long id;
        private String name;
        private String phoneNumber;
        private BigDecimal rating;
        private String vehicleType;
        private String vehicleNumber;
        private BigDecimal currentLatitude;
        private BigDecimal currentLongitude;
    }
}

