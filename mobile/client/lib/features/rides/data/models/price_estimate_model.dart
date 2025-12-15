import '../../domain/entities/price_estimate.dart';

class PriceEstimateModel extends PriceEstimate {
  const PriceEstimateModel({
    required super.price,
    required super.distanceKm,
    required super.estimatedDurationMinutes,
    required super.rideType,
  });

  factory PriceEstimateModel.fromJson(Map<String, dynamic> json) {
    return PriceEstimateModel(
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      estimatedDurationMinutes: (json['estimatedDurationMinutes'] as num?)?.toInt() ?? 0,
      rideType: json['rideType'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'distanceKm': distanceKm,
      'estimatedDurationMinutes': estimatedDurationMinutes,
      'rideType': rideType,
    };
  }
}

