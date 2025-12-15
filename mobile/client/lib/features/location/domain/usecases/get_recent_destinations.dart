import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location.dart';
import '../repositories/location_repository.dart';

class GetRecentDestinations implements UseCaseNoParams<List<Location>> {
  final LocationRepository repository;

  GetRecentDestinations(this.repository);

  @override
  Future<Either<Failure, List<Location>>> call() async {
    return await repository.getRecentDestinations();
  }
}

