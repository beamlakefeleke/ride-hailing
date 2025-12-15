import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    super.phoneNumber,
    super.email,
    super.fullName,
    super.gender,
    super.dateOfBirth,
    super.profileImageUrl,
    required super.emailVerified,
    required super.phoneVerified,
    required super.profileCompleted,
    required super.active,
    required super.walletBalance,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      profileImageUrl: json['profileImageUrl'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      profileCompleted: json['profileCompleted'] as bool? ?? false,
      active: json['active'] as bool? ?? true,
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'email': email,
      'fullName': fullName,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'profileCompleted': profileCompleted,
      'active': active,
      'walletBalance': walletBalance,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      phoneNumber: user.phoneNumber,
      email: user.email,
      fullName: user.fullName,
      gender: user.gender,
      dateOfBirth: user.dateOfBirth,
      profileImageUrl: user.profileImageUrl,
      emailVerified: user.emailVerified,
      phoneVerified: user.phoneVerified,
      profileCompleted: user.profileCompleted,
      active: user.active,
      walletBalance: user.walletBalance,
    );
  }
}

