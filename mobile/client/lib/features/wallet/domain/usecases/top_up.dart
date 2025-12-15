import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wallet_transaction.dart';
import '../repositories/wallet_repository.dart';

class TopUpParams {
  final double amount;
  final String paymentMethod;
  final String? paymentMethodDetails;

  TopUpParams({
    required this.amount,
    required this.paymentMethod,
    this.paymentMethodDetails,
  });
}

class TopUp implements UseCase<WalletTransaction, TopUpParams> {
  final WalletRepository repository;

  TopUp(this.repository);

  @override
  Future<Either<Failure, WalletTransaction>> call(TopUpParams params) async {
    return await repository.topUp(
      amount: params.amount,
      paymentMethod: params.paymentMethod,
      paymentMethodDetails: params.paymentMethodDetails,
    );
  }
}

