package com.ourride.service;

import com.ourride.dto.request.TopUpRequest;
import com.ourride.dto.response.WalletTransactionResponse;
import com.ourride.model.entity.User;
import com.ourride.model.entity.WalletTransaction;
import com.ourride.repository.UserRepository;
import com.ourride.repository.WalletTransactionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class WalletService {
    
    private final UserRepository userRepository;
    private final WalletTransactionRepository walletTransactionRepository;
    
    /**
     * Top up wallet
     */
    @Transactional
    public WalletTransactionResponse topUp(Long userId, TopUpRequest request) {
        log.info("Processing top-up for user: {}, amount: {}", userId, request.getAmount());
        
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        // Create transaction
        String transactionId = "TRX" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        
        WalletTransaction transaction = WalletTransaction.builder()
            .userId(userId)
            .transactionType(WalletTransaction.TransactionType.TOP_UP)
            .amount(request.getAmount())
            .paymentMethod(request.getPaymentMethod())
            .paymentMethodDetails(request.getPaymentMethodDetails())
            .status(WalletTransaction.TransactionStatus.PENDING)
            .transactionId(transactionId)
            .description("Wallet top-up via " + request.getPaymentMethod())
            .build();
        
        transaction = walletTransactionRepository.save(transaction);
        
        // Process payment (in production, integrate with payment gateway)
        // For now, simulate successful payment
        try {
            // Simulate payment processing
            Thread.sleep(100);
            
            // Update transaction status
            transaction.setStatus(WalletTransaction.TransactionStatus.COMPLETED);
            transaction = walletTransactionRepository.save(transaction);
            
            // Update user wallet balance
            BigDecimal newBalance = user.getWalletBalance().add(request.getAmount());
            user.setWalletBalance(newBalance);
            userRepository.save(user);
            
            log.info("Top-up completed for user: {}, new balance: {}", userId, newBalance);
            
        } catch (Exception e) {
            log.error("Payment processing failed for transaction: {}", transactionId, e);
            transaction.setStatus(WalletTransaction.TransactionStatus.FAILED);
            transaction.setDescription("Payment processing failed: " + e.getMessage());
            walletTransactionRepository.save(transaction);
            throw new RuntimeException("Payment processing failed");
        }
        
        return mapToResponse(transaction);
    }
    
    /**
     * Get wallet transaction history
     */
    @Transactional(readOnly = true)
    public List<WalletTransactionResponse> getTransactionHistory(Long userId, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<WalletTransaction> transactions = walletTransactionRepository
            .findByUserIdOrderByCreatedAtDesc(userId, pageable);
        
        return transactions.getContent().stream()
            .map(this::mapToResponse)
            .collect(Collectors.toList());
    }
    
    /**
     * Get top-up transactions only
     */
    @Transactional(readOnly = true)
    public List<WalletTransactionResponse> getTopUpHistory(Long userId) {
        List<WalletTransaction> transactions = walletTransactionRepository
            .findByUserIdAndTransactionTypeOrderByCreatedAtDesc(
                userId, 
                WalletTransaction.TransactionType.TOP_UP
            );
        
        return transactions.stream()
            .map(this::mapToResponse)
            .collect(Collectors.toList());
    }
    
    private WalletTransactionResponse mapToResponse(WalletTransaction transaction) {
        return WalletTransactionResponse.builder()
            .id(transaction.getId())
            .transactionType(transaction.getTransactionType().name())
            .amount(transaction.getAmount())
            .paymentMethod(transaction.getPaymentMethod())
            .paymentMethodDetails(transaction.getPaymentMethodDetails())
            .status(transaction.getStatus().name())
            .transactionId(transaction.getTransactionId())
            .description(transaction.getDescription())
            .createdAt(transaction.getCreatedAt())
            .build();
    }
}

