import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/price_estimate.dart';
import '../../domain/entities/ride.dart';
import '../../domain/repositories/ride_repository.dart';
import '../datasources/ride_remote_data_source.dart';

class RideRepositoryImpl implements RideRepository {
  final RideRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RideRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PriceEstimate>> estimatePrice({
    required double pickupLatitude,
    required double pickupLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    required String rideType,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final estimate = await remoteDataSource.estimatePrice(
          pickupLatitude: pickupLatitude,
          pickupLongitude: pickupLongitude,
          destinationLatitude: destinationLatitude,
          destinationLongitude: destinationLongitude,
          rideType: rideType,
        );
        return Right(estimate);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
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
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final ride = await remoteDataSource.bookRide(
          pickupLatitude: pickupLatitude,
          pickupLongitude: pickupLongitude,
          pickupAddress: pickupAddress,
          destinationLatitude: destinationLatitude,
          destinationLongitude: destinationLongitude,
          destinationAddress: destinationAddress,
          rideType: rideType,
          price: price,
          scheduledDateTime: scheduledDateTime,
        );
        return Right(ride);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Ride>> getRide(int rideId) async {
    if (await networkInfo.isConnected) {
      try {
        final ride = await remoteDataSource.getRide(rideId);
        return Right(ride);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Ride>>> getRideHistory({
    int page = 0,
    int size = 20,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final rides = await remoteDataSource.getRideHistory(
          page: page,
          size: size,
        );
        return Right(rides);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Ride>> cancelRide(int rideId, {String? reason}) async {
    if (await networkInfo.isConnected) {
      try {
        final ride = await remoteDataSource.cancelRide(rideId, reason: reason);
        return Right(ride);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}

