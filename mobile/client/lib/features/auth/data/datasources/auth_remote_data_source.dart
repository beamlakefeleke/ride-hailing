import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendOtp({
    required String phoneNumber,
    required String countryCode,
  });

  Future<void> resendOtp({
    required String phoneNumber,
    required String countryCode,
  });

  Future<AuthResponseModel> verifyOtp({
    required String phoneNumber,
    required String countryCode,
    required String otp,
  });

  Future<AuthResponseModel> socialLogin({
    required String provider,
    required String providerId,
    String? email,
    String? fullName,
    String? profileImageUrl,
    String? accessToken,
  });

  Future<AuthResponseModel> completeProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String countryCode,
    required String gender,
    required DateTime dateOfBirth,
  });

  Future<AuthResponseModel> refreshToken(String refreshToken);

  Future<bool> checkPhone({
    required String phoneNumber,
    required String countryCode,
  });

  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<void> sendOtp({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      await apiClient.post(
        '/auth/send-otp',
        data: {
          'phoneNumber': phoneNumber,
          'countryCode': countryCode,
        },
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> resendOtp({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      await apiClient.post(
        '/auth/resend-otp',
        data: {
          'phoneNumber': phoneNumber,
          'countryCode': countryCode,
        },
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp({
    required String phoneNumber,
    required String countryCode,
    required String otp,
  }) async {
    try {
      final response = await apiClient.post(
        '/auth/verify-otp',
        data: {
          'phoneNumber': phoneNumber,
          'countryCode': countryCode,
          'otp': otp,
        },
      );

      return AuthResponseModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthResponseModel> socialLogin({
    required String provider,
    required String providerId,
    String? email,
    String? fullName,
    String? profileImageUrl,
    String? accessToken,
  }) async {
    try {
      final response = await apiClient.post(
        '/auth/social-login',
        data: {
          'provider': provider,
          'providerId': providerId,
          if (email != null) 'email': email,
          if (fullName != null) 'fullName': fullName,
          if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
          if (accessToken != null) 'accessToken': accessToken,
        },
      );

      return AuthResponseModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthResponseModel> completeProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String countryCode,
    required String gender,
    required DateTime dateOfBirth,
  }) async {
    try {
      final response = await apiClient.post(
        '/auth/complete-profile',
        data: {
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'countryCode': countryCode,
          'gender': gender,
          'dateOfBirth': dateOfBirth.toIso8601String().split('T')[0],
        },
      );

      return AuthResponseModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    try {
      // Temporarily set auth token
      apiClient.setAuthToken(refreshToken);
      final response = await apiClient.post('/auth/refresh-token');
      // Remove token after call
      apiClient.removeAuthToken();

      return AuthResponseModel.fromJson(response);
    } catch (e) {
      apiClient.removeAuthToken();
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> checkPhone({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      final response = await apiClient.get(
        '/auth/check-phone',
        queryParameters: {
          'phoneNumber': phoneNumber,
          'countryCode': countryCode,
        },
      );

      return response['exists'] as bool? ?? false;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get('/auth/me');
      return UserModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}

