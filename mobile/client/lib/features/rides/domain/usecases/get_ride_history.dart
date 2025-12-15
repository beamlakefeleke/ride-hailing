import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ride.dart';
import '../repositories/ride_repository.dart';

class GetRideHistory implements UseCase<List<Ride>, GetRideHistoryParams> {
  final RideRepository repository;

  GetRideHistory(this.repository);

  @override
  Future<Either<Failure, List<Ride>>> call(GetRideHistoryParams params) async {
    return await repository.getRideHistory(
      page: params.page,
      size: params.size,
    );
  }
}

class GetRideHistoryParams extends Params {
  final int page;
  final int size;

  GetRideHistoryParams({
    this.page = 0,
    this.size = 20,
  });

  @override
  List<Object> get props => [page, size];
}

