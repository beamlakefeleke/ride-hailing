package com.ourride.repository;

import com.ourride.model.entity.RideRating;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RideRatingRepository extends JpaRepository<RideRating, Long> {
    
    Optional<RideRating> findByRideIdAndUserId(Long rideId, Long userId);
    
    boolean existsByRideIdAndUserId(Long rideId, Long userId);
}

