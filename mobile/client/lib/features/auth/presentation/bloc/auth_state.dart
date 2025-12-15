import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSent extends AuthState {
  final String message;

  const OtpSent(this.message);

  @override
  List<Object> get props => [message];
}

class OtpResent extends AuthState {
  final String message;

  const OtpResent(this.message);

  @override
  List<Object> get props => [message];
}

class AuthSuccess extends AuthState {
  final AuthResponse authResponse;

  const AuthSuccess(this.authResponse);

  @override
  List<Object> get props => [authResponse];
}

class ProfileCompleted extends AuthState {
  final AuthResponse authResponse;

  const ProfileCompleted(this.authResponse);

  @override
  List<Object> get props => [authResponse];
}

class PhoneChecked extends AuthState {
  final bool exists;

  const PhoneChecked(this.exists);

  @override
  List<Object> get props => [exists];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthLoggedOut extends AuthState {}

