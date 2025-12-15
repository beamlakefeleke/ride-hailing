import 'package:equatable/equatable.dart';
import '../../domain/entities/wallet_transaction.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class TopUpSuccess extends WalletState {
  final WalletTransaction transaction;

  const TopUpSuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionHistoryLoaded extends WalletState {
  final List<WalletTransaction> transactions;

  const TransactionHistoryLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class TopUpHistoryLoaded extends WalletState {
  final List<WalletTransaction> transactions;

  const TopUpHistoryLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}

