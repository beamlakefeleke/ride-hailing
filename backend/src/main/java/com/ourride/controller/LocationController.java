package com.ourride.controller;

import com.ourride.dto.request.LocationSearchRequest;
import com.ourride.dto.request.SaveAddressRequest;
import com.ourride.dto.response.LocationResponse;
import com.ourride.dto.response.SavedAddressResponse;
import com.ourride.service.LocationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/locations")
@RequiredArgsConstructor
public class LocationController {
    
    private final LocationService locationService;
    
    /**
     * Search locations
     * POST /api/locations/search
     */
    @PostMapping("/search")
    public ResponseEntity<List<LocationResponse>> searchLocations(
            @Valid @RequestBody LocationSearchRequest request) {
        List<LocationResponse> locations = locationService.searchLocations(request);
        return ResponseEntity.ok(locations);
    }
    
    /**
     * Get recent destinations
     * GET /api/locations/recent
     */
    @GetMapping("/recent")
    public ResponseEntity<List<LocationResponse>> getRecentDestinations(
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        List<LocationResponse> recentDestinations = locationService.getRecentDestinations(userId);
        return ResponseEntity.ok(recentDestinations);
    }
    
    /**
     * Save an address
     * POST /api/locations/save
     */
    @PostMapping("/save")
    public ResponseEntity<SavedAddressResponse> saveAddress(
            @Valid @RequestBody SaveAddressRequest request,
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        SavedAddressResponse response = locationService.saveAddress(userId, request);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Get all saved addresses
     * GET /api/locations/saved
     */
    @GetMapping("/saved")
    public ResponseEntity<List<SavedAddressResponse>> getSavedAddresses(
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        List<SavedAddressResponse> savedAddresses = locationService.getSavedAddresses(userId);
        return ResponseEntity.ok(savedAddresses);
    }
    
    /**
     * Delete a saved address
     * DELETE /api/locations/saved/{id}
     */
    @DeleteMapping("/saved/{id}")
    public ResponseEntity<Map<String, String>> deleteSavedAddress(
            @PathVariable Long id,
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        locationService.deleteSavedAddress(userId, id);
        return ResponseEntity.ok(Map.of("message", "Address deleted successfully"));
    }
}

