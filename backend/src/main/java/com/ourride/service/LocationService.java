package com.ourride.service;

import com.ourride.dto.request.LocationSearchRequest;
import com.ourride.dto.request.SaveAddressRequest;
import com.ourride.dto.response.LocationResponse;
import com.ourride.dto.response.SavedAddressResponse;
import com.ourride.model.entity.SavedAddress;
import com.ourride.model.entity.User;
import com.ourride.repository.SavedAddressRepository;
import com.ourride.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class LocationService {
    
    private final SavedAddressRepository savedAddressRepository;
    private final UserRepository userRepository;
    
    /**
     * Search locations (placeholder - in production, integrate with Google Places API)
     */
    public List<LocationResponse> searchLocations(LocationSearchRequest request) {
        log.info("Searching locations with query: {}", request.getQuery());
        
        // TODO: Integrate with Google Places API or similar service
        // For now, return empty list or mock data
        // In production, this would call Google Places API:
        // https://developers.google.com/maps/documentation/places/web-service/search-text
        
        return List.of();
    }
    
    /**
     * Get recent destinations for a user
     */
    @Transactional(readOnly = true)
    public List<LocationResponse> getRecentDestinations(Long userId) {
        log.info("Getting recent destinations for user: {}", userId);
        
        // Get recent rides and extract destinations
        // For now, return saved addresses as recent destinations
        List<SavedAddress> savedAddresses = savedAddressRepository
            .findByUserIdOrderByCreatedAtDesc(userId);
        
        return savedAddresses.stream()
            .limit(10) // Limit to 10 most recent
            .map(this::mapToLocationResponse)
            .collect(Collectors.toList());
    }
    
    /**
     * Save an address for a user
     */
    @Transactional
    public SavedAddressResponse saveAddress(Long userId, SaveAddressRequest request) {
        log.info("Saving address for user: {}, name: {}", userId, request.getName());
        
        // Check if user exists
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        // Check if address with same name already exists
        if (savedAddressRepository.existsByUserIdAndName(userId, request.getName())) {
            throw new RuntimeException("Address with this name already exists");
        }
        
        SavedAddress.AddressType addressType = null;
        if (request.getType() != null) {
            try {
                addressType = SavedAddress.AddressType.valueOf(request.getType().toUpperCase());
            } catch (IllegalArgumentException e) {
                log.warn("Invalid address type: {}, defaulting to null", request.getType());
            }
        }
        
        SavedAddress savedAddress = SavedAddress.builder()
            .userId(userId)
            .name(request.getName())
            .address(request.getAddress())
            .latitude(request.getLatitude())
            .longitude(request.getLongitude())
            .type(addressType)
            .build();
        
        savedAddress = savedAddressRepository.save(savedAddress);
        log.info("Address saved with ID: {}", savedAddress.getId());
        
        return mapToSavedAddressResponse(savedAddress);
    }
    
    /**
     * Get all saved addresses for a user
     */
    @Transactional(readOnly = true)
    public List<SavedAddressResponse> getSavedAddresses(Long userId) {
        log.info("Getting saved addresses for user: {}", userId);
        
        List<SavedAddress> savedAddresses = savedAddressRepository
            .findByUserIdOrderByCreatedAtDesc(userId);
        
        return savedAddresses.stream()
            .map(this::mapToSavedAddressResponse)
            .collect(Collectors.toList());
    }
    
    /**
     * Delete a saved address
     */
    @Transactional
    public void deleteSavedAddress(Long userId, Long addressId) {
        log.info("Deleting address {} for user: {}", addressId, userId);
        
        SavedAddress savedAddress = savedAddressRepository
            .findByIdAndUserId(addressId, userId)
            .orElseThrow(() -> new RuntimeException("Address not found"));
        
        savedAddressRepository.delete(savedAddress);
        log.info("Address deleted successfully");
    }
    
    private LocationResponse mapToLocationResponse(SavedAddress savedAddress) {
        return LocationResponse.builder()
            .name(savedAddress.getName())
            .address(savedAddress.getAddress())
            .latitude(savedAddress.getLatitude())
            .longitude(savedAddress.getLongitude())
            .build();
    }
    
    private SavedAddressResponse mapToSavedAddressResponse(SavedAddress savedAddress) {
        return SavedAddressResponse.builder()
            .id(savedAddress.getId())
            .name(savedAddress.getName())
            .address(savedAddress.getAddress())
            .latitude(savedAddress.getLatitude())
            .longitude(savedAddress.getLongitude())
            .type(savedAddress.getType() != null ? savedAddress.getType().name() : null)
            .createdAt(savedAddress.getCreatedAt())
            .build();
    }
}

