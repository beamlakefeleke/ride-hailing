import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class CompleteProfile implements UseCase<AuthResponse, CompleteProfileParams> {
  final AuthRepository repository;

  CompleteProfile(this.repository);

  @override
  Future<Either<Failure, AuthResponse>> call(CompleteProfileParams params) async {
    return await repository.completeProfile(
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      countryCode: params.countryCode,
      gender: params.gender,
      dateOfBirth: params.dateOfBirth,
    );
  }
}

class CompleteProfileParams extends Params {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String gender;
  final DateTime dateOfBirth;

  CompleteProfileParams({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.gender,
    required this.dateOfBirth,
  });

  @override
  List<Object> get props => [
        fullName,
        email,
        phoneNumber,
        countryCode,
        gender,
        dateOfBirth,
      ];
}

