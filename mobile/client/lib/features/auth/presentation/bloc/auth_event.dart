import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String countryCode;

  const SendOtpEvent({
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object> get props => [phoneNumber, countryCode];
}

class ResendOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String countryCode;

  const ResendOtpEvent({
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object> get props => [phoneNumber, countryCode];
}

class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String countryCode;
  final String otp;

  const VerifyOtpEvent({
    required this.phoneNumber,
    required this.countryCode,
    required this.otp,
  });

  @override
  List<Object> get props => [phoneNumber, countryCode, otp];
}

class SocialLoginEvent extends AuthEvent {
  final String provider;
  final String providerId;
  final String? email;
  final String? fullName;
  final String? profileImageUrl;
  final String? accessToken;

  const SocialLoginEvent({
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

class CompleteProfileEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String gender;
  final DateTime dateOfBirth;

  const CompleteProfileEvent({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.gender,
    required this.dateOfBirth,
  });

  @override
  List<Object> get props => [
        fullName,
        email,
        phoneNumber,
        countryCode,
        gender,
        dateOfBirth,
      ];
}

class CheckPhoneEvent extends AuthEvent {
  final String phoneNumber;
  final String countryCode;

  const CheckPhoneEvent({
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object> get props => [phoneNumber, countryCode];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

