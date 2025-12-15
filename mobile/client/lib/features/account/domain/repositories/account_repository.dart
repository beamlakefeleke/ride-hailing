import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user.dart';

abstract class AccountRepository {
  Future<Either<Failure, User>> getProfile();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? countryCode,
    String? gender,
    DateTime? dateOfBirth,
    String? profileImageUrl,
  });
}

