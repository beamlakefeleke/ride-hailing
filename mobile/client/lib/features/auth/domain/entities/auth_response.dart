import 'package:equatable/equatable.dart';
import 'user.dart';

class AuthResponse extends Equatable {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final User? user;
  final bool profileCompleted;
  final bool requiresProfileCompletion;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.user,
    required this.profileCompleted,
    required this.requiresProfileCompletion,
  });

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        expiresIn,
        user,
        profileCompleted,
        requiresProfileCompletion,
      ];
}

