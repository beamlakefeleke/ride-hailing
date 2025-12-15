import 'package:equatable/equatable.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/saved_address.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationsLoaded extends LocationState {
  final List<Location> locations;

  const LocationsLoaded(this.locations);

  @override
  List<Object> get props => [locations];
}

class RecentDestinationsLoaded extends LocationState {
  final List<Location> destinations;

  const RecentDestinationsLoaded(this.destinations);

  @override
  List<Object> get props => [destinations];
}

class SavedAddressesLoaded extends LocationState {
  final List<SavedAddress> addresses;

  const SavedAddressesLoaded(this.addresses);

  @override
  List<Object> get props => [addresses];
}

class AddressSaved extends LocationState {
  final SavedAddress address;

  const AddressSaved(this.address);

  @override
  List<Object> get props => [address];
}

class AddressDeleted extends LocationState {
  const AddressDeleted();
}

class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object> get props => [message];
}

