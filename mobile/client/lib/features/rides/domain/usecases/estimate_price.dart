import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/price_estimate.dart';
import '../repositories/ride_repository.dart';

class EstimatePrice implements UseCase<PriceEstimate, EstimatePriceParams> {
  final RideRepository repository;

  EstimatePrice(this.repository);

  @override
  Future<Either<Failure, PriceEstimate>> call(EstimatePriceParams params) async {
    return await repository.estimatePrice(
      pickupLatitude: params.pickupLatitude,
      pickupLongitude: params.pickupLongitude,
      destinationLatitude: params.destinationLatitude,
      destinationLongitude: params.destinationLongitude,
      rideType: params.rideType,
    );
  }
}

class EstimatePriceParams extends Params {
  final double pickupLatitude;
  final double pickupLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  final String rideType;

  EstimatePriceParams({
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.rideType,
  });

  @override
  List<Object> get props => [
        pickupLatitude,
        pickupLongitude,
        destinationLatitude,
        destinationLongitude,
        rideType,
      ];
}

