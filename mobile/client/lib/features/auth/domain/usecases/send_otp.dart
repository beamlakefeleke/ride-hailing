import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SendOtp implements UseCase<void, SendOtpParams> {
  final AuthRepository repository;

  SendOtp(this.repository);

  @override
  Future<Either<Failure, void>> call(SendOtpParams params) async {
    return await repository.sendOtp(
      phoneNumber: params.phoneNumber,
      countryCode: params.countryCode,
    );
  }
}

class SendOtpParams extends Params {
  final String phoneNumber;
  final String countryCode;

  SendOtpParams({
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object> get props => [phoneNumber, countryCode];
}

