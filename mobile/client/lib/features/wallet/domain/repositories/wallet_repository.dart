import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/wallet_transaction.dart';

abstract class WalletRepository {
  Future<Either<Failure, WalletTransaction>> topUp({
    required double amount,
    required String paymentMethod,
    String? paymentMethodDetails,
  });
  
  Future<Either<Failure, List<WalletTransaction>>> getTransactionHistory({
    int page = 0,
    int size = 20,
  });
  
  Future<Either<Failure, List<WalletTransaction>>> getTopUpHistory();
}

