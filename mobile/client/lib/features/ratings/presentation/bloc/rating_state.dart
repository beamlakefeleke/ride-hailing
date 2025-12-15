import 'package:equatable/equatable.dart';
import '../../domain/entities/ride_rating.dart';

abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object?> get props => [];
}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RideRated extends RatingState {
  final RideRating rating;

  const RideRated(this.rating);

  @override
  List<Object?> get props => [rating];
}

class RideRatingLoaded extends RatingState {
  final RideRating? rating;

  const RideRatingLoaded(this.rating);

  @override
  List<Object?> get props => [rating];
}

class RatingError extends RatingState {
  final String message;

  const RatingError(this.message);

  @override
  List<Object?> get props => [message];
}

