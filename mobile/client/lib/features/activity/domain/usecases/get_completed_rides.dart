import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../rides/domain/entities/ride.dart';
import '../repositories/activity_repository.dart';

class Params {
  final int page;
  final int size;

  Params({this.page = 0, this.size = 20});
}

class GetCompletedRides implements UseCase<List<Ride>, Params> {
  final ActivityRepository repository;

  GetCompletedRides(this.repository);

  @override
  Future<Either<Failure, List<Ride>>> call(Params params) async {
    return await repository.getCompletedRides(page: params.page, size: params.size);
  }
}

