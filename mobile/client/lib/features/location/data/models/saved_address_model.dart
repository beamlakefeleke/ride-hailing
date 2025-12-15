import '../../domain/entities/saved_address.dart';

class SavedAddressModel extends SavedAddress {
  const SavedAddressModel({
    required super.id,
    required super.name,
    required super.address,
    required super.latitude,
    required super.longitude,
    super.type,
    required super.createdAt,
  });

  factory SavedAddressModel.fromJson(Map<String, dynamic> json) {
    return SavedAddressModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      if (type != null) 'type': type,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SavedAddressModel.fromEntity(SavedAddress savedAddress) {
    return SavedAddressModel(
      id: savedAddress.id,
      name: savedAddress.name,
      address: savedAddress.address,
      latitude: savedAddress.latitude,
      longitude: savedAddress.longitude,
      type: savedAddress.type,
      createdAt: savedAddress.createdAt,
    );
  }
}

