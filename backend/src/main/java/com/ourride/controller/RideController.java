package com.ourride.controller;

import com.ourride.dto.request.BookRideRequest;
import com.ourride.dto.request.PriceEstimateRequest;
import com.ourride.dto.response.PriceEstimateResponse;
import com.ourride.dto.response.RideResponse;
import com.ourride.service.RideService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/rides")
@RequiredArgsConstructor
public class RideController {
    
    private final RideService rideService;
    
    /**
     * Estimate price for a ride
     * POST /api/rides/estimate-price
     */
    @PostMapping("/estimate-price")
    public ResponseEntity<PriceEstimateResponse> estimatePrice(
            @Valid @RequestBody PriceEstimateRequest request) {
        PriceEstimateResponse response = rideService.estimatePrice(request);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Book a ride
     * POST /api/rides/book
     */
    @PostMapping("/book")
    public ResponseEntity<RideResponse> bookRide(
            @Valid @RequestBody BookRideRequest request,
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        RideResponse response = rideService.bookRide(userId, request);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Get ride by ID
     * GET /api/rides/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<RideResponse> getRide(
            @PathVariable Long id,
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        RideResponse response = rideService.getRide(userId, id);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Get ride history
     * GET /api/rides/history
     */
    @GetMapping("/history")
    public ResponseEntity<List<RideResponse>> getRideHistory(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String status,
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        Pageable pageable = PageRequest.of(page, size);
        List<RideResponse> history = rideService.getRideHistory(userId, pageable, status);
        return ResponseEntity.ok(history);
    }
    
    /**
     * Get ongoing/active rides
     * GET /api/rides/ongoing
     */
    @GetMapping("/ongoing")
    public ResponseEntity<List<RideResponse>> getOngoingRides(
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        List<RideResponse> ongoingRides = rideService.getOngoingRides(userId);
        return ResponseEntity.ok(ongoingRides);
    }
    
    /**
     * Get scheduled rides
     * GET /api/rides/scheduled
     */
    @GetMapping("/scheduled")
    public ResponseEntity<List<RideResponse>> getScheduledRides(
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        List<RideResponse> scheduledRides = rideService.getScheduledRides(userId);
        return ResponseEntity.ok(scheduledRides);
    }
    
    /**
     * Cancel a ride
     * POST /api/rides/{id}/cancel
     */
    @PostMapping("/{id}/cancel")
    public ResponseEntity<RideResponse> cancelRide(
            @PathVariable Long id,
            @RequestBody(required = false) Map<String, String> request,
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        String reason = request != null ? request.get("reason") : null;
        RideResponse response = rideService.cancelRide(userId, id, reason);
        return ResponseEntity.ok(response);
    }
}

