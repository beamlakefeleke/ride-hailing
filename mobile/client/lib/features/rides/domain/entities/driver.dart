import 'package:equatable/equatable.dart';

class Driver extends Equatable {
  final int id;
  final String name;
  final String? phoneNumber;
  final double rating;
  final String vehicleType;
  final String vehicleNumber;
  final double? currentLatitude;
  final double? currentLongitude;

  const Driver({
    required this.id,
    required this.name,
    this.phoneNumber,
    required this.rating,
    required this.vehicleType,
    required this.vehicleNumber,
    this.currentLatitude,
    this.currentLongitude,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        rating,
        vehicleType,
        vehicleNumber,
        currentLatitude,
        currentLongitude,
      ];
}

