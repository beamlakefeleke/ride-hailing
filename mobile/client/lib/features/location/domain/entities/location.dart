import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double? distance; // Distance in km (optional)

  const Location({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.distance,
  });

  @override
  List<Object?> get props => [name, address, latitude, longitude, distance];
}

