import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wallet_transaction.dart';
import '../repositories/wallet_repository.dart';

class GetTransactionHistoryParams {
  final int page;
  final int size;

  GetTransactionHistoryParams({this.page = 0, this.size = 20});
}

class GetTransactionHistory implements UseCase<List<WalletTransaction>, GetTransactionHistoryParams> {
  final WalletRepository repository;

  GetTransactionHistory(this.repository);

  @override
  Future<Either<Failure, List<WalletTransaction>>> call(GetTransactionHistoryParams params) async {
    return await repository.getTransactionHistory(
      page: params.page,
      size: params.size,
    );
  }
}

