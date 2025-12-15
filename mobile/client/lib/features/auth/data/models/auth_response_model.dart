import '../../domain/entities/auth_response.dart';
import 'user_model.dart';

class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresIn,
    super.user,
    required super.profileCompleted,
    required super.requiresProfileCompletion,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle nested user object
    UserModel? user;
    if (json['user'] != null) {
      if (json['user'] is Map<String, dynamic>) {
        user = UserModel.fromJson(json['user'] as Map<String, dynamic>);
      }
    }

    return AuthResponseModel(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 86400,
      user: user,
      profileCompleted: json['profileCompleted'] as bool? ?? false,
      requiresProfileCompletion:
          json['requiresProfileCompletion'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'user': user != null ? (user as UserModel).toJson() : null,
      'profileCompleted': profileCompleted,
      'requiresProfileCompletion': requiresProfileCompletion,
    };
  }
}

