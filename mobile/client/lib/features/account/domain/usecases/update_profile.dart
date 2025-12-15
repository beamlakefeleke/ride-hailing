import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/account_repository.dart';

class UpdateProfileParams {
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? countryCode;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? profileImageUrl;

  UpdateProfileParams({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.countryCode,
    this.gender,
    this.dateOfBirth,
    this.profileImageUrl,
  });
}

class UpdateProfile implements UseCase<User, UpdateProfileParams> {
  final AccountRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      countryCode: params.countryCode,
      gender: params.gender,
      dateOfBirth: params.dateOfBirth,
      profileImageUrl: params.profileImageUrl,
    );
  }
}

