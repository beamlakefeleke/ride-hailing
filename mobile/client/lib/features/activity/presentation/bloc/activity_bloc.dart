import 'package:bloc/bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_ongoing_rides.dart';
import '../../domain/usecases/get_scheduled_rides.dart';
import '../../domain/usecases/get_completed_rides.dart' as completed;
import '../../domain/usecases/get_cancelled_rides.dart';
import 'activity_event.dart';
import 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final GetOngoingRides getOngoingRides;
  final GetScheduledRides getScheduledRides;
  final completed.GetCompletedRides getCompletedRides;
  final GetCancelledRides getCancelledRides;

  ActivityBloc({
    required this.getOngoingRides,
    required this.getScheduledRides,
    required this.getCompletedRides,
    required this.getCancelledRides,
  }) : super(ActivityInitial()) {
    on<LoadOngoingRidesEvent>(_onLoadOngoingRides);
    on<LoadScheduledRidesEvent>(_onLoadScheduledRides);
    on<LoadCompletedRidesEvent>(_onLoadCompletedRides);
    on<LoadCancelledRidesEvent>(_onLoadCancelledRides);
    on<SwitchTabEvent>(_onSwitchTab);
  }

  Future<void> _onLoadOngoingRides(
    LoadOngoingRidesEvent event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    final result = await getOngoingRides();
    result.fold(
      (failure) => emit(ActivityError(_mapFailureToMessage(failure))),
      (rides) => emit(OngoingRidesLoaded(rides)),
    );
  }

  Future<void> _onLoadScheduledRides(
    LoadScheduledRidesEvent event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    final result = await getScheduledRides();
    result.fold(
      (failure) => emit(ActivityError(_mapFailureToMessage(failure))),
      (rides) => emit(ScheduledRidesLoaded(rides)),
    );
  }

  Future<void> _onLoadCompletedRides(
    LoadCompletedRidesEvent event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    final result = await getCompletedRides(completed.Params(page: event.page, size: event.size));
    result.fold(
      (failure) => emit(ActivityError(_mapFailureToMessage(failure))),
      (rides) => emit(CompletedRidesLoaded(rides)),
    );
  }

  Future<void> _onLoadCancelledRides(
    LoadCancelledRidesEvent event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    final result = await getCancelledRides(completed.Params(page: event.page, size: event.size));
    result.fold(
      (failure) => emit(ActivityError(_mapFailureToMessage(failure))),
      (rides) => emit(CancelledRidesLoaded(rides)),
    );
  }

  Future<void> _onSwitchTab(
    SwitchTabEvent event,
    Emitter<ActivityState> emit,
  ) async {
    // Load data for the selected tab
    switch (event.tabIndex) {
      case 0: // Ongoing
        add(const LoadOngoingRidesEvent());
        break;
      case 1: // Scheduled
        add(const LoadScheduledRidesEvent());
        break;
      case 2: // Completed
        add(const LoadCompletedRidesEvent());
        break;
      case 3: // Cancelled
        add(const LoadCancelledRidesEvent());
        break;
      case 4: // Top Up (not implemented yet)
        // Placeholder for future implementation
        break;
    }
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

