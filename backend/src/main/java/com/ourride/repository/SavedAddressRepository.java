package com.ourride.repository;

import com.ourride.model.entity.SavedAddress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SavedAddressRepository extends JpaRepository<SavedAddress, Long> {
    
    List<SavedAddress> findByUserIdOrderByCreatedAtDesc(Long userId);
    
    List<SavedAddress> findByUserIdAndTypeOrderByCreatedAtDesc(Long userId, SavedAddress.AddressType type);
    
    Optional<SavedAddress> findByIdAndUserId(Long id, Long userId);
    
    boolean existsByUserIdAndName(Long userId, String name);
}

