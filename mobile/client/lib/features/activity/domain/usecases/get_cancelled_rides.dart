import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../rides/domain/entities/ride.dart';
import '../repositories/activity_repository.dart';
import 'get_completed_rides.dart' as completed;

class GetCancelledRides implements UseCase<List<Ride>, completed.Params> {
  final ActivityRepository repository;

  GetCancelledRides(this.repository);

  @override
  Future<Either<Failure, List<Ride>>> call(completed.Params params) async {
    return await repository.getCancelledRides(page: params.page, size: params.size);
  }
}

