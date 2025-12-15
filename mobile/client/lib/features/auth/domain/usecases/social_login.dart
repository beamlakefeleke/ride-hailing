import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class SocialLogin implements UseCase<AuthResponse, SocialLoginParams> {
  final AuthRepository repository;

  SocialLogin(this.repository);

  @override
  Future<Either<Failure, AuthResponse>> call(SocialLoginParams params) async {
    return await repository.socialLogin(
      provider: params.provider,
      providerId: params.providerId,
      email: params.email,
      fullName: params.fullName,
      profileImageUrl: params.profileImageUrl,
      accessToken: params.accessToken,
    );
  }
}

class SocialLoginParams extends Params {
  final String provider;
  final String providerId;
  final String? email;
  final String? fullName;
  final String? profileImageUrl;
  final String? accessToken;

  SocialLoginParams({
    required this.provider,
    required this.providerId,
    this.email,
    this.fullName,
    this.profileImageUrl,
    this.accessToken,
  });

  @override
  List<Object?> get props => [
        provider,
        providerId,
        email,
        fullName,
        profileImageUrl,
        accessToken,
      ];
}

