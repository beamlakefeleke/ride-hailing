package com.ourride.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PriceEstimateResponse {
    
    private BigDecimal price;
    private BigDecimal distanceKm;
    private Integer estimatedDurationMinutes;
    private String rideType;
}

