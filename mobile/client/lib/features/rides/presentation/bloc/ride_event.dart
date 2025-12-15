import 'package:equatable/equatable.dart';

abstract class RideEvent extends Equatable {
  const RideEvent();

  @override
  List<Object> get props => [];
}

class EstimatePriceEvent extends RideEvent {
  final double pickupLatitude;
  final double pickupLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  final String rideType;

  const EstimatePriceEvent({
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.rideType,
  });

  @override
  List<Object> get props => [
        pickupLatitude,
        pickupLongitude,
        destinationLatitude,
        destinationLongitude,
        rideType,
      ];
}

class BookRideEvent extends RideEvent {
  final double pickupLatitude;
  final double pickupLongitude;
  final String pickupAddress;
  final double destinationLatitude;
  final double destinationLongitude;
  final String destinationAddress;
  final String rideType;
  final double price;
  final DateTime? scheduledDateTime;

  const BookRideEvent({
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.pickupAddress,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.destinationAddress,
    required this.rideType,
    required this.price,
    this.scheduledDateTime,
  });

  @override
  List<Object> get props => [
        pickupLatitude,
        pickupLongitude,
        pickupAddress,
        destinationLatitude,
        destinationLongitude,
        destinationAddress,
        rideType,
        price,
        scheduledDateTime?.toString() ?? '',
      ];
}

class GetRideEvent extends RideEvent {
  final int rideId;

  const GetRideEvent({required this.rideId});

  @override
  List<Object> get props => [rideId];
}

class GetRideHistoryEvent extends RideEvent {
  final int page;
  final int size;

  const GetRideHistoryEvent({
    this.page = 0,
    this.size = 20,
  });

  @override
  List<Object> get props => [page, size];
}

class CancelRideEvent extends RideEvent {
  final int rideId;
  final String? reason;

  const CancelRideEvent({
    required this.rideId,
    this.reason,
  });

  @override
  List<Object> get props => [rideId, reason ?? ''];
}

