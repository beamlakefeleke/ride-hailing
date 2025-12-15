import '../../domain/entities/driver.dart';

class DriverModel extends Driver {
  const DriverModel({
    required super.id,
    required super.name,
    super.phoneNumber,
    required super.rating,
    required super.vehicleType,
    required super.vehicleNumber,
    super.currentLatitude,
    super.currentLongitude,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      vehicleType: json['vehicleType'] as String? ?? '',
      vehicleNumber: json['vehicleNumber'] as String? ?? '',
      currentLatitude: (json['currentLatitude'] as num?)?.toDouble(),
      currentLongitude: (json['currentLongitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'rating': rating,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      if (currentLatitude != null) 'currentLatitude': currentLatitude,
      if (currentLongitude != null) 'currentLongitude': currentLongitude,
    };
  }
}

