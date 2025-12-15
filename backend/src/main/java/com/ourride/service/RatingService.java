package com.ourride.service;

import com.ourride.dto.request.RateRideRequest;
import com.ourride.dto.response.RideRatingResponse;
import com.ourride.model.entity.Ride;
import com.ourride.model.entity.RideRating;
import com.ourride.repository.RideRatingRepository;
import com.ourride.repository.RideRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class RatingService {
    
    private final RideRatingRepository ratingRepository;
    private final RideRepository rideRepository;
    
    /**
     * Rate a completed ride
     */
    @Transactional
    public RideRatingResponse rateRide(Long userId, Long rideId, RateRideRequest request) {
        log.info("Rating ride {} by user {}", rideId, userId);
        
        // Verify ride exists and belongs to user
        Ride ride = rideRepository.findById(rideId)
            .orElseThrow(() -> new RuntimeException("Ride not found"));
        
        if (!ride.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: Ride does not belong to user");
        }
        
        // Verify ride is completed
        if (ride.getStatus() != Ride.RideStatus.COMPLETED) {
            throw new RuntimeException("Can only rate completed rides");
        }
        
        // Check if already rated
        if (ratingRepository.existsByRideIdAndUserId(rideId, userId)) {
            throw new RuntimeException("Ride already rated");
        }
        
        // Create rating
        RideRating rating = RideRating.builder()
            .rideId(rideId)
            .userId(userId)
            .driverId(ride.getDriverId())
            .rating(request.getRating())
            .comment(request.getComment())
            .build();
        
        rating = ratingRepository.save(rating);
        log.info("Rating saved: {}", rating.getId());
        
        return mapToResponse(rating);
    }
    
    /**
     * Get rating for a ride
     */
    @Transactional(readOnly = true)
    public Optional<RideRatingResponse> getRideRating(Long rideId, Long userId) {
        return ratingRepository.findByRideIdAndUserId(rideId, userId)
            .map(this::mapToResponse);
    }
    
    private RideRatingResponse mapToResponse(RideRating rating) {
        return RideRatingResponse.builder()
            .id(rating.getId())
            .rideId(rating.getRideId())
            .rating(rating.getRating())
            .comment(rating.getComment())
            .createdAt(rating.getCreatedAt())
            .build();
    }
}

