import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_address.dart';
import '../repositories/location_repository.dart';

class SaveAddress implements UseCase<SavedAddress, SaveAddressParams> {
  final LocationRepository repository;

  SaveAddress(this.repository);

  @override
  Future<Either<Failure, SavedAddress>> call(SaveAddressParams params) async {
    return await repository.saveAddress(
      name: params.name,
      address: params.address,
      latitude: params.latitude,
      longitude: params.longitude,
      type: params.type,
    );
  }
}

class SaveAddressParams extends Params {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? type;

  SaveAddressParams({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.type,
  });

  @override
  List<Object?> get props => [name, address, latitude, longitude, type];
}

