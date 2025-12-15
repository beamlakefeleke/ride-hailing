import 'package:equatable/equatable.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

class LoadOngoingRidesEvent extends ActivityEvent {
  const LoadOngoingRidesEvent();
}

class LoadScheduledRidesEvent extends ActivityEvent {
  const LoadScheduledRidesEvent();
}

class LoadCompletedRidesEvent extends ActivityEvent {
  final int page;
  final int size;

  const LoadCompletedRidesEvent({this.page = 0, this.size = 20});

  @override
  List<Object> get props => [page, size];
}

class LoadCancelledRidesEvent extends ActivityEvent {
  final int page;
  final int size;

  const LoadCancelledRidesEvent({this.page = 0, this.size = 20});

  @override
  List<Object> get props => [page, size];
}

class SwitchTabEvent extends ActivityEvent {
  final int tabIndex;

  const SwitchTabEvent(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

