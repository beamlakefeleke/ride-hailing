import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/location_repository.dart';

class DeleteSavedAddress implements UseCase<void, DeleteSavedAddressParams> {
  final LocationRepository repository;

  DeleteSavedAddress(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteSavedAddressParams params) async {
    return await repository.deleteSavedAddress(params.addressId);
  }
}

class DeleteSavedAddressParams extends Params {
  final int addressId;

  DeleteSavedAddressParams({required this.addressId});

  @override
  List<Object> get props => [addressId];
}

