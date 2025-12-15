package com.ourride.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "ride_ratings", indexes = {
    @Index(name = "idx_ride_ratings_ride_id", columnList = "rideId"),
    @Index(name = "idx_ride_ratings_user_id", columnList = "userId"),
    @Index(name = "idx_ride_ratings_driver_id", columnList = "driverId")
})
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RideRating {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "ride_id", nullable = false)
    private Long rideId;
    
    @Column(name = "user_id", nullable = false)
    private Long userId;
    
    @Column(name = "driver_id", nullable = false)
    private Long driverId;
    
    @Column(nullable = false)
    private Integer rating; // 1-5
    
    @Column(columnDefinition = "TEXT")
    private String comment;
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
}

