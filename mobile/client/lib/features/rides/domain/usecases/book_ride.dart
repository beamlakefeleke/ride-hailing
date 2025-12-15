import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ride.dart';
import '../repositories/ride_repository.dart';

class BookRide implements UseCase<Ride, BookRideParams> {
  final RideRepository repository;

  BookRide(this.repository);

  @override
  Future<Either<Failure, Ride>> call(BookRideParams params) async {
    return await repository.bookRide(
      pickupLatitude: params.pickupLatitude,
      pickupLongitude: params.pickupLongitude,
      pickupAddress: params.pickupAddress,
      destinationLatitude: params.destinationLatitude,
      destinationLongitude: params.destinationLongitude,
      destinationAddress: params.destinationAddress,
      rideType: params.rideType,
      price: params.price,
      scheduledDateTime: params.scheduledDateTime,
    );
  }
}

class BookRideParams extends Params {
  final double pickupLatitude;
  final double pickupLongitude;
  final String pickupAddress;
  final double destinationLatitude;
  final double destinationLongitude;
  final String destinationAddress;
  final String rideType;
  final double price;
  final DateTime? scheduledDateTime;

  BookRideParams({
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
  List<Object?> get props => [
        pickupLatitude,
        pickupLongitude,
        pickupAddress,
        destinationLatitude,
        destinationLongitude,
        destinationAddress,
        rideType,
        price,
        scheduledDateTime,
      ];
}

