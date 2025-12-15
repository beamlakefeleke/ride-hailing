package com.ourride.repository;

import com.ourride.model.entity.Ride;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface RideRepository extends JpaRepository<Ride, Long> {
    
    List<Ride> findByUserIdOrderByCreatedAtDesc(Long userId);
    
    Page<Ride> findByUserIdOrderByCreatedAtDesc(Long userId, Pageable pageable);
    
    List<Ride> findByUserIdAndStatusOrderByCreatedAtDesc(Long userId, Ride.RideStatus status);
    
    Page<Ride> findByUserIdAndStatusOrderByCreatedAtDesc(Long userId, Ride.RideStatus status, Pageable pageable);
    
    List<Ride> findByDriverIdAndStatusOrderByCreatedAtDesc(Long driverId, Ride.RideStatus status);
    
    Optional<Ride> findByIdAndUserId(Long id, Long userId);
    
    @Query("SELECT r FROM Ride r WHERE r.userId = :userId AND r.status IN :statuses ORDER BY r.createdAt DESC")
    List<Ride> findByUserIdAndStatusIn(@Param("userId") Long userId, @Param("statuses") List<Ride.RideStatus> statuses);
    
    @Query("SELECT r FROM Ride r WHERE r.userId = :userId AND r.createdAt >= :startDate AND r.createdAt <= :endDate ORDER BY r.createdAt DESC")
    List<Ride> findByUserIdAndDateRange(@Param("userId") Long userId, 
                                         @Param("startDate") LocalDateTime startDate, 
                                         @Param("endDate") LocalDateTime endDate);
    
    List<Ride> findByStatusAndScheduledDateTimeLessThanEqual(Ride.RideStatus status, LocalDateTime dateTime);
    
    List<Ride> findByUserIdAndScheduledDateTimeIsNotNullOrderByScheduledDateTimeAsc(Long userId);
}

