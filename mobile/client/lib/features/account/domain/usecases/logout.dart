import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/account_repository.dart';

class Logout implements UseCaseNoParams<void> {
  final AccountRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}

