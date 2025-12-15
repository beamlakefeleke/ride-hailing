import '../../../../core/network/api_client.dart';
import '../../../auth/data/models/user_model.dart';

abstract class AccountRemoteDataSource {
  Future<UserModel> getProfile();
  Future<void> logout();
  Future<UserModel> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? countryCode,
    String? gender,
    DateTime? dateOfBirth,
    String? profileImageUrl,
  });
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final ApiClient apiClient;

  AccountRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> getProfile() async {
    final response = await apiClient.get('/api/auth/profile');
    return UserModel.fromJson(response);
  }

  @override
  Future<void> logout() async {
    await apiClient.post('/api/auth/logout', data: {});
  }

  @override
  Future<UserModel> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? countryCode,
    String? gender,
    DateTime? dateOfBirth,
    String? profileImageUrl,
  }) async {
    final Map<String, dynamic> data = {};
    if (fullName != null) data['fullName'] = fullName;
    if (email != null) data['email'] = email;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (countryCode != null) data['countryCode'] = countryCode;
    if (gender != null) data['gender'] = gender;
    if (dateOfBirth != null) data['dateOfBirth'] = dateOfBirth.toIso8601String().split('T')[0];
    if (profileImageUrl != null) data['profileImageUrl'] = profileImageUrl;

    final response = await apiClient.put('/api/auth/profile', data: data);
    return UserModel.fromJson(response);
  }
}

