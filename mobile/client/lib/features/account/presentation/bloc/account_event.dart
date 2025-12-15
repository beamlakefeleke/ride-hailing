import 'package:equatable/equatable.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileEvent extends AccountEvent {
  const GetProfileEvent();
}

class LogoutEvent extends AccountEvent {
  const LogoutEvent();
}

class UpdateProfileEvent extends AccountEvent {
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? countryCode;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? profileImageUrl;

  const UpdateProfileEvent({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.countryCode,
    this.gender,
    this.dateOfBirth,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [
        fullName,
        email,
        phoneNumber,
        countryCode,
        gender,
        dateOfBirth,
        profileImageUrl,
      ];
}

