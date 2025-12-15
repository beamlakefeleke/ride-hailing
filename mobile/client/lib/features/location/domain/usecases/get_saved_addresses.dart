import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_address.dart';
import '../repositories/location_repository.dart';

class GetSavedAddresses implements UseCaseNoParams<List<SavedAddress>> {
  final LocationRepository repository;

  GetSavedAddresses(this.repository);

  @override
  Future<Either<Failure, List<SavedAddress>>> call() async {
    return await repository.getSavedAddresses();
  }
}

