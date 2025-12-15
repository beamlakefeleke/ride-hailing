package com.ourride.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LocationSearchRequest {
    
    @NotBlank(message = "Search query is required")
    private String query;
    
    private Double latitude; // Optional: for location-based search
    
    private Double longitude; // Optional: for location-based search
}

