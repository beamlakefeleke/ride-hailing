package com.ourride.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookRideRequest {
    
    @NotNull(message = "Pickup latitude is required")
    private BigDecimal pickupLatitude;
    
    @NotNull(message = "Pickup longitude is required")
    private BigDecimal pickupLongitude;
    
    @NotBlank(message = "Pickup address is required")
    private String pickupAddress;
    
    @NotNull(message = "Destination latitude is required")
    private BigDecimal destinationLatitude;
    
    @NotNull(message = "Destination longitude is required")
    private BigDecimal destinationLongitude;
    
    @NotBlank(message = "Destination address is required")
    private String destinationAddress;
    
    @NotBlank(message = "Ride type is required")
    private String rideType; // CAR, CAR_XL, CAR_PLUS
    
    @NotNull(message = "Price is required")
    private BigDecimal price;
    
    private LocalDateTime scheduledDateTime; // Optional: for scheduled rides
}

