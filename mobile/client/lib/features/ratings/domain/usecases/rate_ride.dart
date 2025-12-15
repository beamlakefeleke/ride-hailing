import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ride_rating.dart';
import '../repositories/rating_repository.dart';

class RateRideParams {
  final int rideId;
  final int rating;
  final String? comment;

  RateRideParams({
    required this.rideId,
    required this.rating,
    this.comment,
  });
}

class RateRide implements UseCase<RideRating, RateRideParams> {
  final RatingRepository repository;

  RateRide(this.repository);

  @override
  Future<Either<Failure, RideRating>> call(RateRideParams params) async {
    return await repository.rateRide(
      rideId: params.rideId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

