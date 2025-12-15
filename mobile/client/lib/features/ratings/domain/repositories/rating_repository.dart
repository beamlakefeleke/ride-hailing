import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ride_rating.dart';

abstract class RatingRepository {
  Future<Either<Failure, RideRating>> rateRide({
    required int rideId,
    required int rating,
    String? comment,
  });
  
  Future<Either<Failure, RideRating?>> getRideRating(int rideId);
}

