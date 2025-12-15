import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String? phoneNumber;
  final String? email;
  final String? fullName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? profileImageUrl;
  final bool emailVerified;
  final bool phoneVerified;
  final bool profileCompleted;
  final bool active;
  final double walletBalance;

  const User({
    required this.id,
    this.phoneNumber,
    this.email,
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.profileImageUrl,
    required this.emailVerified,
    required this.phoneVerified,
    required this.profileCompleted,
    required this.active,
    required this.walletBalance,
  });

  @override
  List<Object?> get props => [
        id,
        phoneNumber,
        email,
        fullName,
        gender,
        dateOfBirth,
        profileImageUrl,
        emailVerified,
        phoneVerified,
        profileCompleted,
        active,
        walletBalance,
      ];
}

