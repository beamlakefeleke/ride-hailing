import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class VerifyOtp implements UseCase<AuthResponse, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  @override
  Future<Either<Failure, AuthResponse>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(
      phoneNumber: params.phoneNumber,
      countryCode: params.countryCode,
      otp: params.otp,
    );
  }
}

class VerifyOtpParams extends Params {
  final String phoneNumber;
  final String countryCode;
  final String otp;

  VerifyOtpParams({
    required this.phoneNumber,
    required this.countryCode,
    required this.otp,
  });

  @override
  List<Object> get props => [phoneNumber, countryCode, otp];
}

