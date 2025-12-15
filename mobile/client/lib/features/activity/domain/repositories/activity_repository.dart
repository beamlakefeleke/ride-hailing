import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../rides/domain/entities/ride.dart';

abstract class ActivityRepository {
  Future<Either<Failure, List<Ride>>> getOngoingRides();
  Future<Either<Failure, List<Ride>>> getScheduledRides();
  Future<Either<Failure, List<Ride>>> getCompletedRides({int page = 0, int size = 20});
  Future<Either<Failure, List<Ride>>> getCancelledRides({int page = 0, int size = 20});
}

