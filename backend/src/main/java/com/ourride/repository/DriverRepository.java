package com.ourride.repository;

import com.ourride.model.entity.Driver;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
public interface DriverRepository extends JpaRepository<Driver, Long> {
    
    Optional<Driver> findByUserId(Long userId);
    
    List<Driver> findByIsAvailableTrue();
    
    @Query("SELECT d FROM Driver d WHERE d.isAvailable = true AND d.currentLatitude IS NOT NULL AND d.currentLongitude IS NOT NULL " +
           "ORDER BY SQRT(POWER((d.currentLatitude - :lat) * 111.0, 2) + POWER((d.currentLongitude - :lng) * 111.0 * COS(RADIANS(:lat)), 2)) ASC")
    List<Driver> findNearestAvailableDrivers(@Param("lat") BigDecimal latitude, @Param("lng") BigDecimal longitude);
    
    @Query("SELECT d FROM Driver d WHERE d.isAvailable = true AND d.vehicleType = :vehicleType " +
           "AND d.currentLatitude IS NOT NULL AND d.currentLongitude IS NOT NULL " +
           "ORDER BY SQRT(POWER((d.currentLatitude - :lat) * 111.0, 2) + POWER((d.currentLongitude - :lng) * 111.0 * COS(RADIANS(:lat)), 2)) ASC")
    List<Driver> findNearestAvailableDriversByVehicleType(@Param("lat") BigDecimal latitude, 
                                                           @Param("lng") BigDecimal longitude,
                                                           @Param("vehicleType") String vehicleType);
}

