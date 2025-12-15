package com.ourride.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RideRatingResponse {
    private Long id;
    private Long rideId;
    private Integer rating;
    private String comment;
    private LocalDateTime createdAt;
}

