import '../../domain/entities/ride_rating.dart';

class RideRatingModel extends RideRating {
  const RideRatingModel({
    required super.id,
    required super.rideId,
    required super.rating,
    super.comment,
    required super.createdAt,
  });

  factory RideRatingModel.fromJson(Map<String, dynamic> json) {
    return RideRatingModel(
      id: json['id'] as int,
      rideId: json['rideId'] as int,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rideId': rideId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

