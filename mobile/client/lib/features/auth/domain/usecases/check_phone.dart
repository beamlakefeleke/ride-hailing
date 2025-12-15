import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class CheckPhone implements UseCase<bool, CheckPhoneParams> {
  final AuthRepository repository;

  CheckPhone(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckPhoneParams params) async {
    return await repository.checkPhone(
      phoneNumber: params.phoneNumber,
      countryCode: params.countryCode,
    );
  }
}

class CheckPhoneParams extends Params {
  final String phoneNumber;
  final String countryCode;

  CheckPhoneParams({
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object> get props => [phoneNumber, countryCode];
}

