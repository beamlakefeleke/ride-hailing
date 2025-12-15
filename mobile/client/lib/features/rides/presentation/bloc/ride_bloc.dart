import 'package:bloc/bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/book_ride.dart';
import '../../domain/usecases/cancel_ride.dart';
import '../../domain/usecases/estimate_price.dart';
import '../../domain/usecases/get_ride.dart';
import '../../domain/usecases/get_ride_history.dart';
import 'ride_event.dart';
import 'ride_state.dart';

class RideBloc extends Bloc<RideEvent, RideState> {
  final EstimatePrice estimatePrice;
  final BookRide bookRide;
  final GetRide getRide;
  final GetRideHistory getRideHistory;
  final CancelRide cancelRide;

  RideBloc({
    required this.estimatePrice,
    required this.bookRide,
    required this.getRide,
    required this.getRideHistory,
    required this.cancelRide,
  }) : super(RideInitial()) {
    on<EstimatePriceEvent>(_onEstimatePrice);
    on<BookRideEvent>(_onBookRide);
    on<GetRideEvent>(_onGetRide);
    on<GetRideHistoryEvent>(_onGetRideHistory);
    on<CancelRideEvent>(_onCancelRide);
  }

  Future<void> _onEstimatePrice(
    EstimatePriceEvent event,
    Emitter<RideState> emit,
  ) async {
    emit(RideLoading());
    final result = await estimatePrice(
      EstimatePriceParams(
        pickupLatitude: event.pickupLatitude,
        pickupLongitude: event.pickupLongitude,
        destinationLatitude: event.destinationLatitude,
        destinationLongitude: event.destinationLongitude,
        rideType: event.rideType,
      ),
    );
    result.fold(
      (failure) => emit(RideError(_mapFailureToMessage(failure))),
      (estimate) => emit(PriceEstimated(estimate)),
    );
  }

  Future<void> _onBookRide(
    BookRideEvent event,
    Emitter<RideState> emit,
  ) async {
    emit(RideLoading());
    final result = await bookRide(
      BookRideParams(
        pickupLatitude: event.pickupLatitude,
        pickupLongitude: event.pickupLongitude,
        pickupAddress: event.pickupAddress,
        destinationLatitude: event.destinationLatitude,
        destinationLongitude: event.destinationLongitude,
        destinationAddress: event.destinationAddress,
        rideType: event.rideType,
        price: event.price,
        scheduledDateTime: event.scheduledDateTime,
      ),
    );
    result.fold(
      (failure) => emit(RideError(_mapFailureToMessage(failure))),
      (ride) => emit(RideBooked(ride)),
    );
  }

  Future<void> _onGetRide(
    GetRideEvent event,
    Emitter<RideState> emit,
  ) async {
    emit(RideLoading());
    final result = await getRide(GetRideParams(rideId: event.rideId));
    result.fold(
      (failure) => emit(RideError(_mapFailureToMessage(failure))),
      (ride) => emit(RideLoaded(ride)),
    );
  }

  Future<void> _onGetRideHistory(
    GetRideHistoryEvent event,
    Emitter<RideState> emit,
  ) async {
    emit(RideLoading());
    final result = await getRideHistory(
      GetRideHistoryParams(page: event.page, size: event.size),
    );
    result.fold(
      (failure) => emit(RideError(_mapFailureToMessage(failure))),
      (rides) => emit(RideHistoryLoaded(rides)),
    );
  }

  Future<void> _onCancelRide(
    CancelRideEvent event,
    Emitter<RideState> emit,
  ) async {
    emit(RideLoading());
    final result = await cancelRide(
      CancelRideParams(rideId: event.rideId, reason: event.reason),
    );
    result.fold(
      (failure) => emit(RideError(_mapFailureToMessage(failure))),
      (ride) => emit(RideCancelled(ride)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case NetworkFailure:
        return (failure as NetworkFailure).message;
      default:
        return 'Unexpected error occurred';
    }
  }
}

