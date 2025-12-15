import 'package:equatable/equatable.dart';
import '../../../rides/domain/entities/ride.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class OngoingRidesLoaded extends ActivityState {
  final List<Ride> rides;

  const OngoingRidesLoaded(this.rides);

  @override
  List<Object> get props => [rides];
}

class ScheduledRidesLoaded extends ActivityState {
  final List<Ride> rides;

  const ScheduledRidesLoaded(this.rides);

  @override
  List<Object> get props => [rides];
}

class CompletedRidesLoaded extends ActivityState {
  final List<Ride> rides;

  const CompletedRidesLoaded(this.rides);

  @override
  List<Object> get props => [rides];
}

class CancelledRidesLoaded extends ActivityState {
  final List<Ride> rides;

  const CancelledRidesLoaded(this.rides);

  @override
  List<Object> get props => [rides];
}

class ActivityError extends ActivityState {
  final String message;

  const ActivityError(this.message);

  @override
  List<Object> get props => [message];
}

