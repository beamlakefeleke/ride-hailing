import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ride.dart';
import '../repositories/ride_repository.dart';

class GetRide implements UseCase<Ride, GetRideParams> {
  final RideRepository repository;

  GetRide(this.repository);

  @override
  Future<Either<Failure, Ride>> call(GetRideParams params) async {
    return await repository.getRide(params.rideId);
  }
}

class GetRideParams extends Params {
  final int rideId;

  GetRideParams({required this.rideId});

  @override
  List<Object> get props => [rideId];
}

