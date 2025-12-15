import 'package:bloc/bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/delete_saved_address.dart';
import '../../domain/usecases/get_recent_destinations.dart';
import '../../domain/usecases/get_saved_addresses.dart';
import '../../domain/usecases/save_address.dart';
import '../../domain/usecases/search_locations.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final SearchLocations searchLocations;
  final GetRecentDestinations getRecentDestinations;
  final GetSavedAddresses getSavedAddresses;
  final SaveAddress saveAddress;
  final DeleteSavedAddress deleteSavedAddress;

  LocationBloc({
    required this.searchLocations,
    required this.getRecentDestinations,
    required this.getSavedAddresses,
    required this.saveAddress,
    required this.deleteSavedAddress,
  }) : super(LocationInitial()) {
    on<SearchLocationsEvent>(_onSearchLocations);
    on<GetRecentDestinationsEvent>(_onGetRecentDestinations);
    on<GetSavedAddressesEvent>(_onGetSavedAddresses);
    on<SaveAddressEvent>(_onSaveAddress);
    on<DeleteSavedAddressEvent>(_onDeleteSavedAddress);
  }

  Future<void> _onSearchLocations(
    SearchLocationsEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    final result = await searchLocations(SearchLocationsParams(query: event.query));
    result.fold(
      (failure) => emit(LocationError(_mapFailureToMessage(failure))),
      (locations) => emit(LocationsLoaded(locations)),
    );
  }

  Future<void> _onGetRecentDestinations(
    GetRecentDestinationsEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    final result = await getRecentDestinations();
    result.fold(
      (failure) => emit(LocationError(_mapFailureToMessage(failure))),
      (destinations) => emit(RecentDestinationsLoaded(destinations)),
    );
  }

  Future<void> _onGetSavedAddresses(
    GetSavedAddressesEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    final result = await getSavedAddresses();
    result.fold(
      (failure) => emit(LocationError(_mapFailureToMessage(failure))),
      (addresses) => emit(SavedAddressesLoaded(addresses)),
    );
  }

  Future<void> _onSaveAddress(
    SaveAddressEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    final result = await saveAddress(
      SaveAddressParams(
        name: event.name,
        address: event.address,
        latitude: event.latitude,
        longitude: event.longitude,
        type: event.type,
      ),
    );
    result.fold(
      (failure) => emit(LocationError(_mapFailureToMessage(failure))),
      (address) => emit(AddressSaved(address)),
    );
  }

  Future<void> _onDeleteSavedAddress(
    DeleteSavedAddressEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    final result = await deleteSavedAddress(
      DeleteSavedAddressParams(addressId: event.addressId),
    );
    result.fold(
      (failure) => emit(LocationError(_mapFailureToMessage(failure))),
      (_) => emit(const AddressDeleted()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case NetworkFailure:
        return (failure as NetworkFailure).message;
      case CacheFailure:
        return (failure as CacheFailure).message;
      default:
        return 'Unexpected error occurred';
    }
  }
}

