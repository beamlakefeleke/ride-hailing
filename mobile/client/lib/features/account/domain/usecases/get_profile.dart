import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/account_repository.dart';

class GetProfile implements UseCaseNoParams<User> {
  final AccountRepository repository;

  GetProfile(this.repository);

  @override
  Future<Either<Failure, User>> call() async {
    return await repository.getProfile();
  }
}

