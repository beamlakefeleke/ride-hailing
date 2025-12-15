import 'package:equatable/equatable.dart';

class SavedAddress extends Equatable {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? type; // HOME, OFFICE, APARTMENT, OTHER
  final DateTime createdAt;

  const SavedAddress({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.type,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, address, latitude, longitude, type, createdAt];
}

