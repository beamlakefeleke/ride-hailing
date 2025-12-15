import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> sendOtp({
    required String phoneNumber,
    required String countryCode,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendOtp(
          phoneNumber: phoneNumber,
          countryCode: countryCode,
        );
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp({
    required String phoneNumber,
    required String countryCode,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resendOtp(
          phoneNumber: phoneNumber,
          countryCode: countryCode,
        );
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> verifyOtp({
    required String phoneNumber,
    required String countryCode,
    required String otp,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.verifyOtp(
          phoneNumber: phoneNumber,
          countryCode: countryCode,
          otp: otp,
        );

        // Cache tokens and user
        await localDataSource.cacheAuthTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        );

        if (response.user != null) {
          final userModel = response.user is UserModel
              ? response.user as UserModel
              : UserModel.fromEntity(response.user!);
          await localDataSource.cacheUser(userModel);
        }

        return Right(response);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> socialLogin({
    required String provider,
    required String providerId,
    String? email,
    String? fullName,
    String? profileImageUrl,
    String? accessToken,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.socialLogin(
          provider: provider,
          providerId: providerId,
          email: email,
          fullName: fullName,
          profileImageUrl: profileImageUrl,
          accessToken: accessToken,
        );

        // Cache tokens and user
        await localDataSource.cacheAuthTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        );

        if (response.user != null) {
          final userModel = response.user is UserModel
              ? response.user as UserModel
              : UserModel.fromEntity(response.user!);
          await localDataSource.cacheUser(userModel);
        }

        return Right(response);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> completeProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String countryCode,
    required String gender,
    required DateTime dateOfBirth,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.completeProfile(
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          countryCode: countryCode,
          gender: gender,
          dateOfBirth: dateOfBirth,
        );

        // Update cached tokens and user
        await localDataSource.cacheAuthTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        );

        if (response.user != null) {
          final userModel = response.user is UserModel
              ? response.user as UserModel
              : UserModel.fromEntity(response.user!);
          await localDataSource.cacheUser(userModel);
        }

        return Right(response);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> refreshToken(String refreshToken) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.refreshToken(refreshToken);

        // Update cached tokens
        await localDataSource.cacheAuthTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        );

        return Right(response);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkPhone({
    required String phoneNumber,
    required String countryCode,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final exists = await remoteDataSource.checkPhone(
          phoneNumber: phoneNumber,
          countryCode: countryCode,
        );
        return Right(exists);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }

      if (await networkInfo.isConnected) {
        final user = await remoteDataSource.getCurrentUser();
        await localDataSource.cacheUser(user);
        return Right(user);
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearTokens();
      await localDataSource.clearUser();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await localDataSource.isAuthenticated();
  }
}

