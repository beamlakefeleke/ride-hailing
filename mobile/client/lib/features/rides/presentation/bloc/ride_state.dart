import 'package:equatable/equatable.dart';
import '../../domain/entities/price_estimate.dart';
import '../../domain/entities/ride.dart';

abstract class RideState extends Equatable {
  const RideState();

  @override
  List<Object> get props => [];
}

class RideInitial extends RideState {}

class RideLoading extends RideState {}

class PriceEstimated extends RideState {
  final PriceEstimate estimate;

  const PriceEstimated(this.estimate);

  @override
  List<Object> get props => [estimate];
}

class RideBooked extends RideState {
  final Ride ride;

  const RideBooked(this.ride);

  @override
  List<Object> get props => [ride];
}

class RideLoaded extends RideState {
  final Ride ride;

  const RideLoaded(this.ride);

  @override
  List<Object> get props => [ride];
}

class RideHistoryLoaded extends RideState {
  final List<Ride> rides;

  const RideHistoryLoaded(this.rides);

  @override
  List<Object> get props => [rides];
}

class RideCancelled extends RideState {
  final Ride ride;

  const RideCancelled(this.ride);

  @override
  List<Object> get props => [ride];
}

class RideError extends RideState {
  final String message;

  const RideError(this.message);

  @override
  List<Object> get props => [message];
}

