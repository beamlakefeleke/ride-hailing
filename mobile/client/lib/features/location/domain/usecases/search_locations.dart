import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location.dart';
import '../repositories/location_repository.dart';

class SearchLocations implements UseCase<List<Location>, SearchLocationsParams> {
  final LocationRepository repository;

  SearchLocations(this.repository);

  @override
  Future<Either<Failure, List<Location>>> call(SearchLocationsParams params) async {
    return await repository.searchLocations(params.query);
  }
}

class SearchLocationsParams extends Params {
  final String query;

  SearchLocationsParams({required this.query});

  @override
  List<Object> get props => [query];
}

