package com.ourride.controller;

import com.ourride.dto.request.TopUpRequest;
import com.ourride.dto.response.WalletTransactionResponse;
import com.ourride.service.WalletService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/wallet")
@RequiredArgsConstructor
public class WalletController {
    
    private final WalletService walletService;
    
    /**
     * Top up wallet
     * POST /api/wallet/top-up
     */
    @PostMapping("/top-up")
    public ResponseEntity<WalletTransactionResponse> topUp(
            @Valid @RequestBody TopUpRequest request,
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        WalletTransactionResponse response = walletService.topUp(userId, request);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Get transaction history
     * GET /api/wallet/transactions?page=0&size=20
     */
    @GetMapping("/transactions")
    public ResponseEntity<List<WalletTransactionResponse>> getTransactionHistory(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        List<WalletTransactionResponse> transactions = walletService.getTransactionHistory(userId, page, size);
        return ResponseEntity.ok(transactions);
    }
    
    /**
     * Get top-up history only
     * GET /api/wallet/top-ups
     */
    @GetMapping("/top-ups")
    public ResponseEntity<List<WalletTransactionResponse>> getTopUpHistory(
            Authentication authentication) {
        Long userId = Long.parseLong(authentication.getName());
        List<WalletTransactionResponse> topUps = walletService.getTopUpHistory(userId);
        return ResponseEntity.ok(topUps);
    }
}

