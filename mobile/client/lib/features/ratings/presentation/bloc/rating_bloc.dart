import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/rate_ride.dart';
import '../../domain/usecases/get_ride_rating.dart';
import '../bloc/rating_event.dart';
import '../bloc/rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RateRide rateRide;
  final GetRideRating getRideRating;

  RatingBloc({
    required this.rateRide,
    required this.getRideRating,
  }) : super(RatingInitial()) {
    on<RateRideEvent>(_onRateRide);
    on<GetRideRatingEvent>(_onGetRideRating);
  }

  Future<void> _onRateRide(
    RateRideEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingLoading());
    
    final result = await rateRide(RateRideParams(
      rideId: event.rideId,
      rating: event.rating,
      comment: event.comment,
    ));
    
    result.fold(
      (failure) => emit(RatingError(failure.message)),
      (rating) => emit(RideRated(rating)),
    );
  }

  Future<void> _onGetRideRating(
    GetRideRatingEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingLoading());
    
    final result = await getRideRating(GetRideRatingParams(rideId: event.rideId));
    
    result.fold(
      (failure) => emit(RatingError(failure.message)),
      (rating) => emit(RideRatingLoaded(rating)),
    );
  }
}

