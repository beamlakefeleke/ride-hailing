import '../../domain/entities/location.dart';

class LocationModel extends Location {
  const LocationModel({
    required super.name,
    required super.address,
    required super.latitude,
    required super.longitude,
    super.distance,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      distance: (json['distance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      if (distance != null) 'distance': distance,
    };
  }

  factory LocationModel.fromEntity(Location location) {
    return LocationModel(
      name: location.name,
      address: location.address,
      latitude: location.latitude,
      longitude: location.longitude,
      distance: location.distance,
    );
  }
}

