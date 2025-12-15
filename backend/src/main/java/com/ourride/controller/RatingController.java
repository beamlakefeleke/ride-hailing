package com.ourride.controller;

import com.ourride.dto.request.RateRideRequest;
import com.ourride.dto.response.RideRatingResponse;
import com.ourride.service.RatingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/ratings")
@RequiredArgsConstructor
public class RatingController {
    
    private final RatingService ratingService;
    
    /**
     * Rate a completed ride
     * POST /api/ratings/rides/{rideId}
     */
    @PostMapping("/rides/{rideId}")
    public ResponseEntity<RideRatingResponse> rateRide(
            @PathVariable Long rideId,
            @Valid @RequestBody RateRideRequest request,
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        RideRatingResponse response = ratingService.rateRide(userId, rideId, request);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Get rating for a ride
     * GET /api/ratings/rides/{rideId}
     */
    @GetMapping("/rides/{rideId}")
    public ResponseEntity<RideRatingResponse> getRideRating(
            @PathVariable Long rideId,
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        Optional<RideRatingResponse> rating = ratingService.getRideRating(rideId, userId);
        
        if (rating.isPresent()) {
            return ResponseEntity.ok(rating.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}

