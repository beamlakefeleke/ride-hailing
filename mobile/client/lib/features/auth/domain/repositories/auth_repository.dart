import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../entities/auth_response.dart';

abstract class AuthRepository {
  /// Send OTP to phone number
  Future<Either<Failure, void>> sendOtp({
    required String phoneNumber,
    required String countryCode,
  });

  /// Resend OTP
  Future<Either<Failure, void>> resendOtp({
    required String phoneNumber,
    required String countryCode,
  });

  /// Verify OTP and authenticate (handles both sign-up and sign-in)
  Future<Either<Failure, AuthResponse>> verifyOtp({
    required String phoneNumber,
    required String countryCode,
    required String otp,
  });

  /// Social login (Google, Apple, Facebook, X)
  Future<Either<Failure, AuthResponse>> socialLogin({
    required String provider,
    required String providerId,
    String? email,
    String? fullName,
    String? profileImageUrl,
    String? accessToken,
  });

  /// Complete user profile
  Future<Either<Failure, AuthResponse>> completeProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String countryCode,
    required String gender,
    required DateTime dateOfBirth,
  });

  /// Refresh access token
  Future<Either<Failure, AuthResponse>> refreshToken(String refreshToken);

  /// Check if phone number exists
  Future<Either<Failure, bool>> checkPhone({
    required String phoneNumber,
    required String countryCode,
  });

  /// Get current user
  Future<Either<Failure, User>> getCurrentUser();

  /// Logout
  Future<Either<Failure, void>> logout();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}

