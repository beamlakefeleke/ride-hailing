import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/location.dart';
import '../entities/saved_address.dart';

abstract class LocationRepository {
  Future<Either<Failure, List<Location>>> searchLocations(String query);
  
  Future<Either<Failure, List<Location>>> getRecentDestinations();
  
  Future<Either<Failure, List<SavedAddress>>> getSavedAddresses();
  
  Future<Either<Failure, SavedAddress>> saveAddress({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    String? type,
  });
  
  Future<Either<Failure, void>> deleteSavedAddress(int addressId);
}

