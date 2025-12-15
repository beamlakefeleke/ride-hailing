import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class SearchLocationsEvent extends LocationEvent {
  final String query;

  const SearchLocationsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class GetRecentDestinationsEvent extends LocationEvent {
  const GetRecentDestinationsEvent();
}

class GetSavedAddressesEvent extends LocationEvent {
  const GetSavedAddressesEvent();
}

class SaveAddressEvent extends LocationEvent {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? type;

  const SaveAddressEvent({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.type,
  });

  @override
  List<Object> get props => [name, address, latitude, longitude, type ?? ''];
}

class DeleteSavedAddressEvent extends LocationEvent {
  final int addressId;

  const DeleteSavedAddressEvent({required this.addressId});

  @override
  List<Object> get props => [addressId];
}

