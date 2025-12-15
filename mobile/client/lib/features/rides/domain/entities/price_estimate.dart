import 'package:equatable/equatable.dart';

class PriceEstimate extends Equatable {
  final double price;
  final double distanceKm;
  final int estimatedDurationMinutes;
  final String rideType;

  const PriceEstimate({
    required this.price,
    required this.distanceKm,
    required this.estimatedDurationMinutes,
    required this.rideType,
  });

  @override
  List<Object> get props => [price, distanceKm, estimatedDurationMinutes, rideType];
}

