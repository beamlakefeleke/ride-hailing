import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../rides/domain/entities/ride.dart';
import '../repositories/activity_repository.dart';

class GetScheduledRides implements UseCaseNoParams<List<Ride>> {
  final ActivityRepository repository;

  GetScheduledRides(this.repository);

  @override
  Future<Either<Failure, List<Ride>>> call() async {
    return await repository.getScheduledRides();
  }
}

