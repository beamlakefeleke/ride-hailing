import '../../domain/entities/ride.dart';
import '../../domain/entities/driver.dart';
import 'driver_model.dart';

class RideModel extends Ride {
  const RideModel({
    required super.id,
    required super.userId,
    super.driverId,
    required super.pickupLatitude,
    required super.pickupLongitude,
    required super.pickupAddress,
    required super.destinationLatitude,
    required super.destinationLongitude,
    required super.destinationAddress,
    required super.rideType,
    required super.status,
    required super.price,
    super.distanceKm,
    super.estimatedDurationMinutes,
    super.scheduledDateTime,
    super.startedAt,
    super.completedAt,
    super.cancelledAt,
    super.cancellationReason,
    required super.createdAt,
    required super.updatedAt,
    super.driver,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    Driver? driver;
    if (json['driver'] != null && json['driver'] is Map<String, dynamic>) {
      driver = DriverModel.fromJson(json['driver'] as Map<String, dynamic>);
    }

    return RideModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      driverId: (json['driverId'] as num?)?.toInt(),
      pickupLatitude: (json['pickupLatitude'] as num?)?.toDouble() ?? 0.0,
      pickupLongitude: (json['pickupLongitude'] as num?)?.toDouble() ?? 0.0,
      pickupAddress: json['pickupAddress'] as String? ?? '',
      destinationLatitude: (json['destinationLatitude'] as num?)?.toDouble() ?? 0.0,
      destinationLongitude: (json['destinationLongitude'] as num?)?.toDouble() ?? 0.0,
      destinationAddress: json['destinationAddress'] as String? ?? '',
      rideType: json['rideType'] as String? ?? '',
      status: json['status'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      estimatedDurationMinutes: (json['estimatedDurationMinutes'] as num?)?.toInt(),
      scheduledDateTime: json['scheduledDateTime'] != null
          ? DateTime.parse(json['scheduledDateTime'] as String)
          : null,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'] as String)
          : null,
      cancellationReason: json['cancellationReason'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      driver: driver,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      if (driverId != null) 'driverId': driverId,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'pickupAddress': pickupAddress,
      'destinationLatitude': destinationLatitude,
      'destinationLongitude': destinationLongitude,
      'destinationAddress': destinationAddress,
      'rideType': rideType,
      'status': status,
      'price': price,
      if (distanceKm != null) 'distanceKm': distanceKm,
      if (estimatedDurationMinutes != null) 'estimatedDurationMinutes': estimatedDurationMinutes,
      if (scheduledDateTime != null) 'scheduledDateTime': scheduledDateTime!.toIso8601String(),
      if (startedAt != null) 'startedAt': startedAt!.toIso8601String(),
      if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt!.toIso8601String(),
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (driver != null) 'driver': (driver as DriverModel).toJson(),
    };
  }
}

