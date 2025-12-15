import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/price_estimate.dart';
import '../entities/ride.dart';

abstract class RideRepository {
  Future<Either<Failure, PriceEstimate>> estimatePrice({
    required double pickupLatitude,
    required double pickupLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    required String rideType,
  });

  Future<Either<Failure, Ride>> bookRide({
    required double pickupLatitude,
    required double pickupLongitude,
    required String pickupAddress,
    required double destinationLatitude,
    required double destinationLongitude,
    required String destinationAddress,
    required String rideType,
    required double price,
    DateTime? scheduledDateTime,
  });

  Future<Either<Failure, Ride>> getRide(int rideId);

  Future<Either<Failure, List<Ride>>> getRideHistory({
    int page = 0,
    int size = 20,
  });

  Future<Either<Failure, Ride>> cancelRide(int rideId, {String? reason});
}

