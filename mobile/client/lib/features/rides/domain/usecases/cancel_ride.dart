import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ride.dart';
import '../repositories/ride_repository.dart';

class CancelRide implements UseCase<Ride, CancelRideParams> {
  final RideRepository repository;

  CancelRide(this.repository);

  @override
  Future<Either<Failure, Ride>> call(CancelRideParams params) async {
    return await repository.cancelRide(params.rideId, reason: params.reason);
  }
}

class CancelRideParams extends Params {
  final int rideId;
  final String? reason;

  CancelRideParams({
    required this.rideId,
    this.reason,
  });

  @override
  List<Object?> get props => [rideId, reason];
}

