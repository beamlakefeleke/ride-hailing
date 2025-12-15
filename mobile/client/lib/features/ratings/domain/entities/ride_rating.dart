import 'package:equatable/equatable.dart';

class RideRating extends Equatable {
  final int id;
  final int rideId;
  final int rating; // 1-5
  final String? comment;
  final DateTime createdAt;

  const RideRating({
    required this.id,
    required this.rideId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, rideId, rating, comment, createdAt];
}

