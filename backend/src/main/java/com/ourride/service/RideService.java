package com.ourride.service;

import com.ourride.dto.request.BookRideRequest;
import com.ourride.dto.request.PriceEstimateRequest;
import com.ourride.dto.response.PriceEstimateResponse;
import com.ourride.dto.response.RideResponse;
import com.ourride.model.entity.Driver;
import com.ourride.model.entity.Ride;
import com.ourride.model.entity.User;
import com.ourride.repository.DriverRepository;
import com.ourride.repository.RideRepository;
import com.ourride.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class RideService {
    
    private final RideRepository rideRepository;
    private final DriverRepository driverRepository;
    private final UserRepository userRepository;
    
    // Base prices per km for different ride types
    private static final BigDecimal BASE_PRICE_CAR = new BigDecimal("1.50");
    private static final BigDecimal BASE_PRICE_CAR_XL = new BigDecimal("2.00");
    private static final BigDecimal BASE_PRICE_CAR_PLUS = new BigDecimal("2.25");
    private static final BigDecimal MINIMUM_FARE = new BigDecimal("5.00");
    
    /**
     * Estimate price for a ride
     */
    @Transactional(readOnly = true)
    public PriceEstimateResponse estimatePrice(PriceEstimateRequest request) {
        log.info("Estimating price for ride type: {}", request.getRideType());
        
        // Calculate distance using Haversine formula
        BigDecimal distanceKm = calculateDistance(
            request.getPickupLatitude(),
            request.getPickupLongitude(),
            request.getDestinationLatitude(),
            request.getDestinationLongitude()
        );
        
        // Calculate estimated duration (assuming average speed of 30 km/h in city)
        int estimatedDurationMinutes = distanceKm
            .divide(new BigDecimal("0.5"), 0, RoundingMode.HALF_UP)
            .intValue();
        
        // Calculate price based on ride type
        BigDecimal price = calculatePrice(distanceKm, request.getRideType());
        
        return PriceEstimateResponse.builder()
            .price(price)
            .distanceKm(distanceKm.setScale(2, RoundingMode.HALF_UP))
            .estimatedDurationMinutes(estimatedDurationMinutes)
            .rideType(request.getRideType())
            .build();
    }
    
    /**
     * Book a ride
     */
    @Transactional
    public RideResponse bookRide(Long userId, BookRideRequest request) {
        log.info("Booking ride for user: {}, ride type: {}", userId, request.getRideType());
        
        // Verify user exists
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        // Validate ride type
        Ride.RideType rideType;
        try {
            rideType = Ride.RideType.valueOf(request.getRideType().toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Invalid ride type: " + request.getRideType());
        }
        
        // Create ride
        Ride ride = Ride.builder()
            .userId(userId)
            .pickupLatitude(request.getPickupLatitude())
            .pickupLongitude(request.getPickupLongitude())
            .pickupAddress(request.getPickupAddress())
            .destinationLatitude(request.getDestinationLatitude())
            .destinationLongitude(request.getDestinationLongitude())
            .destinationAddress(request.getDestinationAddress())
            .rideType(rideType)
            .status(Ride.RideStatus.PENDING)
            .price(request.getPrice())
            .scheduledDateTime(request.getScheduledDateTime())
            .build();
        
        // Calculate distance
        BigDecimal distanceKm = calculateDistance(
            request.getPickupLatitude(),
            request.getPickupLongitude(),
            request.getDestinationLatitude(),
            request.getDestinationLongitude()
        );
        ride.setDistanceKm(distanceKm);
        
        // Calculate estimated duration
        int estimatedDurationMinutes = distanceKm
            .divide(new BigDecimal("0.5"), 0, RoundingMode.HALF_UP)
            .intValue();
        ride.setEstimatedDurationMinutes(estimatedDurationMinutes);
        
        // If not scheduled, try to assign driver immediately
        if (request.getScheduledDateTime() == null) {
            assignDriver(ride);
        }
        
        ride = rideRepository.save(ride);
        log.info("Ride booked with ID: {}", ride.getId());
        
        return mapToRideResponse(ride);
    }
    
    /**
     * Get ride by ID
     */
    @Transactional(readOnly = true)
    public RideResponse getRide(Long userId, Long rideId) {
        log.info("Getting ride {} for user: {}", rideId, userId);
        
        Ride ride = rideRepository.findByIdAndUserId(rideId, userId)
            .orElseThrow(() -> new RuntimeException("Ride not found"));
        
        return mapToRideResponse(ride);
    }
    
    /**
     * Get ride history for a user
     */
    @Transactional(readOnly = true)
    public List<RideResponse> getRideHistory(Long userId, Pageable pageable, String status) {
        log.info("Getting ride history for user: {}, status: {}", userId, status);
        
        Page<Ride> rides;
        if (status != null && !status.isEmpty()) {
            try {
                Ride.RideStatus rideStatus = Ride.RideStatus.valueOf(status.toUpperCase());
                rides = rideRepository.findByUserIdAndStatusOrderByCreatedAtDesc(userId, rideStatus, pageable);
            } catch (IllegalArgumentException e) {
                log.warn("Invalid status: {}, returning all rides", status);
                rides = rideRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable);
            }
        } else {
            rides = rideRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable);
        }
        
        return rides.getContent().stream()
            .map(this::mapToRideResponse)
            .collect(Collectors.toList());
    }
    
    /**
     * Get ongoing/active rides for a user
     * Ongoing rides are: PENDING, DRIVER_ASSIGNED, DRIVER_EN_ROUTE, ARRIVED, IN_PROGRESS
     */
    @Transactional(readOnly = true)
    public List<RideResponse> getOngoingRides(Long userId) {
        log.info("Getting ongoing rides for user: {}", userId);
        
        List<Ride.RideStatus> ongoingStatuses = List.of(
            Ride.RideStatus.PENDING,
            Ride.RideStatus.DRIVER_ASSIGNED,
            Ride.RideStatus.DRIVER_EN_ROUTE,
            Ride.RideStatus.ARRIVED,
            Ride.RideStatus.IN_PROGRESS
        );
        
        List<Ride> rides = rideRepository.findByUserIdAndStatusIn(userId, ongoingStatuses);
        
        return rides.stream()
            .sorted((r1, r2) -> r2.getCreatedAt().compareTo(r1.getCreatedAt()))
            .map(this::mapToRideResponse)
            .collect(Collectors.toList());
    }
    
    /**
     * Get scheduled rides for a user
     */
    @Transactional(readOnly = true)
    public List<RideResponse> getScheduledRides(Long userId) {
        log.info("Getting scheduled rides for user: {}", userId);
        
        List<Ride> rides = rideRepository.findByUserIdAndScheduledDateTimeIsNotNullOrderByScheduledDateTimeAsc(userId);
        
        // Filter out completed and cancelled scheduled rides
        LocalDateTime now = LocalDateTime.now();
        rides = rides.stream()
            .filter(ride -> ride.getScheduledDateTime().isAfter(now))
            .filter(ride -> ride.getStatus() != Ride.RideStatus.COMPLETED)
            .filter(ride -> ride.getStatus() != Ride.RideStatus.CANCELLED)
            .collect(Collectors.toList());
        
        return rides.stream()
            .map(this::mapToRideResponse)
            .collect(Collectors.toList());
    }
    
    /**
     * Cancel a ride
     */
    @Transactional
    public RideResponse cancelRide(Long userId, Long rideId, String reason) {
        log.info("Cancelling ride {} for user: {}", rideId, userId);
        
        Ride ride = rideRepository.findByIdAndUserId(rideId, userId)
            .orElseThrow(() -> new RuntimeException("Ride not found"));
        
        if (ride.getStatus() == Ride.RideStatus.COMPLETED) {
            throw new RuntimeException("Cannot cancel a completed ride");
        }
        
        if (ride.getStatus() == Ride.RideStatus.CANCELLED) {
            throw new RuntimeException("Ride is already cancelled");
        }
        
        ride.setStatus(Ride.RideStatus.CANCELLED);
        ride.setCancelledAt(LocalDateTime.now());
        ride.setCancellationReason(reason);
        
        // If driver was assigned, make them available again
        if (ride.getDriverId() != null) {
            driverRepository.findById(ride.getDriverId()).ifPresent(driver -> {
                driver.setIsAvailable(true);
                driverRepository.save(driver);
            });
        }
        
        ride = rideRepository.save(ride);
        log.info("Ride cancelled successfully");
        
        return mapToRideResponse(ride);
    }
    
    /**
     * Assign a driver to a ride
     */
    private void assignDriver(Ride ride) {
        log.info("Assigning driver for ride type: {}", ride.getRideType());
        
        List<Driver> availableDrivers;
        
        // Find nearest available driver matching vehicle type
        String vehicleType = ride.getRideType().name();
        availableDrivers = driverRepository.findNearestAvailableDriversByVehicleType(
            ride.getPickupLatitude(),
            ride.getPickupLongitude(),
            vehicleType
        );
        
        // If no driver with exact vehicle type, find any available driver
        if (availableDrivers.isEmpty()) {
            availableDrivers = driverRepository.findNearestAvailableDrivers(
                ride.getPickupLatitude(),
                ride.getPickupLongitude()
            );
        }
        
        if (!availableDrivers.isEmpty()) {
            Driver driver = availableDrivers.get(0);
            ride.setDriverId(driver.getId());
            ride.setStatus(Ride.RideStatus.DRIVER_ASSIGNED);
            
            // Mark driver as unavailable
            driver.setIsAvailable(false);
            driverRepository.save(driver);
            
            log.info("Driver {} assigned to ride {}", driver.getId(), ride.getId());
        } else {
            log.warn("No available drivers found for ride {}", ride.getId());
        }
    }
    
    /**
     * Calculate distance between two points using Haversine formula
     */
    private BigDecimal calculateDistance(BigDecimal lat1, BigDecimal lng1, 
                                       BigDecimal lat2, BigDecimal lng2) {
        final int EARTH_RADIUS_KM = 6371;
        
        double lat1Rad = Math.toRadians(lat1.doubleValue());
        double lat2Rad = Math.toRadians(lat2.doubleValue());
        double deltaLat = Math.toRadians(lat2.doubleValue() - lat1.doubleValue());
        double deltaLng = Math.toRadians(lng2.doubleValue() - lng1.doubleValue());
        
        double a = Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
                   Math.cos(lat1Rad) * Math.cos(lat2Rad) *
                   Math.sin(deltaLng / 2) * Math.sin(deltaLng / 2);
        
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        double distance = EARTH_RADIUS_KM * c;
        
        return BigDecimal.valueOf(distance).setScale(2, RoundingMode.HALF_UP);
    }
    
    /**
     * Calculate price based on distance and ride type
     */
    private BigDecimal calculatePrice(BigDecimal distanceKm, String rideType) {
        BigDecimal basePrice;
        
        switch (rideType.toUpperCase()) {
            case "CAR":
                basePrice = BASE_PRICE_CAR;
                break;
            case "CAR_XL":
                basePrice = BASE_PRICE_CAR_XL;
                break;
            case "CAR_PLUS":
                basePrice = BASE_PRICE_CAR_PLUS;
                break;
            default:
                basePrice = BASE_PRICE_CAR;
        }
        
        BigDecimal price = distanceKm.multiply(basePrice);
        
        // Apply minimum fare
        if (price.compareTo(MINIMUM_FARE) < 0) {
            price = MINIMUM_FARE;
        }
        
        return price.setScale(2, RoundingMode.HALF_UP);
    }
    
    /**
     * Map Ride entity to RideResponse DTO
     */
    private RideResponse mapToRideResponse(Ride ride) {
        RideResponse.RideResponseBuilder builder = RideResponse.builder()
            .id(ride.getId())
            .userId(ride.getUserId())
            .driverId(ride.getDriverId())
            .pickupLatitude(ride.getPickupLatitude())
            .pickupLongitude(ride.getPickupLongitude())
            .pickupAddress(ride.getPickupAddress())
            .destinationLatitude(ride.getDestinationLatitude())
            .destinationLongitude(ride.getDestinationLongitude())
            .destinationAddress(ride.getDestinationAddress())
            .rideType(ride.getRideType().name())
            .status(ride.getStatus().name())
            .price(ride.getPrice())
            .distanceKm(ride.getDistanceKm())
            .estimatedDurationMinutes(ride.getEstimatedDurationMinutes())
            .scheduledDateTime(ride.getScheduledDateTime())
            .startedAt(ride.getStartedAt())
            .completedAt(ride.getCompletedAt())
            .cancelledAt(ride.getCancelledAt())
            .cancellationReason(ride.getCancellationReason())
            .createdAt(ride.getCreatedAt())
            .updatedAt(ride.getUpdatedAt());
        
        // If driver is assigned, fetch driver info
        if (ride.getDriverId() != null) {
            driverRepository.findById(ride.getDriverId()).ifPresent(driver -> {
                User driverUser = userRepository.findById(driver.getUserId()).orElse(null);
                builder.driver(RideResponse.DriverInfo.builder()
                    .id(driver.getId())
                    .name(driverUser != null ? driverUser.getFullName() : "Driver")
                    .phoneNumber(driverUser != null ? driverUser.getPhoneNumber() : null)
                    .rating(driver.getRating())
                    .vehicleType(driver.getVehicleType())
                    .vehicleNumber(driver.getVehicleNumber())
                    .currentLatitude(driver.getCurrentLatitude())
                    .currentLongitude(driver.getCurrentLongitude())
                    .build());
            });
        }
        
        return builder.build();
    }
}

