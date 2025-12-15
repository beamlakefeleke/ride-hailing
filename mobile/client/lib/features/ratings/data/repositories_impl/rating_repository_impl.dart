import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/ride_rating.dart';
import '../../domain/repositories/rating_repository.dart';
import '../datasources/rating_remote_data_source.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RatingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, RideRating>> rateRide({
    required int rideId,
    required int rating,
    String? comment,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final ratingModel = await remoteDataSource.rateRide(
          rideId: rideId,
          rating: rating,
          comment: comment,
        );
        return Right(ratingModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, RideRating?>> getRideRating(int rideId) async {
    if (await networkInfo.isConnected) {
      try {
        final rating = await remoteDataSource.getRideRating(rideId);
        return Right(rating);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}

