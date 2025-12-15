import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wallet_transaction.dart';
import '../repositories/wallet_repository.dart';

class GetTopUpHistory implements UseCaseNoParams<List<WalletTransaction>> {
  final WalletRepository repository;

  GetTopUpHistory(this.repository);

  @override
  Future<Either<Failure, List<WalletTransaction>>> call() async {
    return await repository.getTopUpHistory();
  }
}

