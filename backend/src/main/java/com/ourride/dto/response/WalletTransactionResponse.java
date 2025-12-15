package com.ourride.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WalletTransactionResponse {
    private Long id;
    private String transactionType;
    private BigDecimal amount;
    private String paymentMethod;
    private String paymentMethodDetails;
    private String status;
    private String transactionId;
    private String description;
    private LocalDateTime createdAt;
}

