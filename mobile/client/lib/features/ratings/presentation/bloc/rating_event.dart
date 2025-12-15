import 'package:equatable/equatable.dart';

abstract class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object?> get props => [];
}

class RateRideEvent extends RatingEvent {
  final int rideId;
  final int rating;
  final String? comment;

  const RateRideEvent({
    required this.rideId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [rideId, rating, comment];
}

class GetRideRatingEvent extends RatingEvent {
  final int rideId;

  const GetRideRatingEvent({required this.rideId});

  @override
  List<Object?> get props => [rideId];
}

