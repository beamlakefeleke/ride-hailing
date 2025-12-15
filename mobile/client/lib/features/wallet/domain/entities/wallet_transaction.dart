import 'package:equatable/equatable.dart';

class WalletTransaction extends Equatable {
  final int id;
  final String transactionType; // TOP_UP, RIDE_PAYMENT, REFUND, WITHDRAWAL
  final double amount;
  final String? paymentMethod;
  final String? paymentMethodDetails;
  final String status; // PENDING, COMPLETED, FAILED, CANCELLED
  final String? transactionId;
  final String? description;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.transactionType,
    required this.amount,
    this.paymentMethod,
    this.paymentMethodDetails,
    required this.status,
    this.transactionId,
    this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        transactionType,
        amount,
        paymentMethod,
        paymentMethodDetails,
        status,
        transactionId,
        description,
        createdAt,
      ];
}

