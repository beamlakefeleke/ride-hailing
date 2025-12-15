package com.ourride.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PriceEstimateRequest {
    
    @NotNull(message = "Pickup latitude is required")
    private BigDecimal pickupLatitude;
    
    @NotNull(message = "Pickup longitude is required")
    private BigDecimal pickupLongitude;
    
    @NotNull(message = "Destination latitude is required")
    private BigDecimal destinationLatitude;
    
    @NotNull(message = "Destination longitude is required")
    private BigDecimal destinationLongitude;
    
    @NotNull(message = "Ride type is required")
    private String rideType; // CAR, CAR_XL, CAR_PLUS
}

