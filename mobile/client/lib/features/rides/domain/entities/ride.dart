import 'package:equatable/equatable.dart';
import 'driver.dart';

class Ride extends Equatable {
  final int id;
  final int userId;
  final int? driverId;
  final double pickupLatitude;
  final double pickupLongitude;
  final String pickupAddress;
  final double destinationLatitude;
  final double destinationLongitude;
  final String destinationAddress;
  final String rideType; // CAR, CAR_XL, CAR_PLUS
  final String status; // PENDING, DRIVER_ASSIGNED, etc.
  final double price;
  final double? distanceKm;
  final int? estimatedDurationMinutes;
  final DateTime? scheduledDateTime;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Driver? driver;

  const Ride({
    required this.id,
    required this.userId,
    this.driverId,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.pickupAddress,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.destinationAddress,
    required this.rideType,
    required this.status,
    required this.price,
    this.distanceKm,
    this.estimatedDurationMinutes,
    this.scheduledDateTime,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
    this.driver,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        driverId,
        pickupLatitude,
        pickupLongitude,
        pickupAddress,
        destinationLatitude,
        destinationLongitude,
        destinationAddress,
        rideType,
        status,
        price,
        distanceKm,
        estimatedDurationMinutes,
        scheduledDateTime,
        startedAt,
        completedAt,
        cancelledAt,
        cancellationReason,
        createdAt,
        updatedAt,
        driver,
      ];
}

