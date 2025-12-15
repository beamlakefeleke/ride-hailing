import '../../domain/entities/wallet_transaction.dart';

class WalletTransactionModel extends WalletTransaction {
  const WalletTransactionModel({
    required super.id,
    required super.transactionType,
    required super.amount,
    super.paymentMethod,
    super.paymentMethodDetails,
    required super.status,
    super.transactionId,
    super.description,
    required super.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] as int,
      transactionType: json['transactionType'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String?,
      paymentMethodDetails: json['paymentMethodDetails'] as String?,
      status: json['status'] as String,
      transactionId: json['transactionId'] as String?,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionType': transactionType,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paymentMethodDetails': paymentMethodDetails,
      'status': status,
      'transactionId': transactionId,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

