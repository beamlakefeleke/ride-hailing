import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ride_rating.dart';
import '../repositories/rating_repository.dart';

class GetRideRatingParams {
  final int rideId;

  GetRideRatingParams({required this.rideId});
}

class GetRideRating implements UseCase<RideRating?, GetRideRatingParams> {
  final RatingRepository repository;

  GetRideRating(this.repository);

  @override
  Future<Either<Failure, RideRating?>> call(GetRideRatingParams params) async {
    return await repository.getRideRating(params.rideId);
  }
}

