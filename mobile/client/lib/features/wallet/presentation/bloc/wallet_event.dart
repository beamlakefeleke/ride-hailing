import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class TopUpEvent extends WalletEvent {
  final double amount;
  final String paymentMethod;
  final String? paymentMethodDetails;

  const TopUpEvent({
    required this.amount,
    required this.paymentMethod,
    this.paymentMethodDetails,
  });

  @override
  List<Object?> get props => [amount, paymentMethod, paymentMethodDetails];
}

class GetTransactionHistoryEvent extends WalletEvent {
  final int page;
  final int size;

  const GetTransactionHistoryEvent({this.page = 0, this.size = 20});

  @override
  List<Object?> get props => [page, size];
}

class GetTopUpHistoryEvent extends WalletEvent {
  const GetTopUpHistoryEvent();
}

