import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/saved_address.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_data_source.dart';
import '../datasources/location_remote_data_source.dart';
import '../models/location_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;
  final LocationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  LocationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Location>>> searchLocations(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final locations = await remoteDataSource.searchLocations(query);
        return Right(locations);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Location>>> getRecentDestinations() async {
    if (await networkInfo.isConnected) {
      try {
        final locations = await remoteDataSource.getRecentDestinations();
        return Right(locations);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Return cached saved addresses as recent destinations if offline
      try {
        final cachedAddresses = await localDataSource.getCachedSavedAddresses();
        final locations = cachedAddresses
            .map((address) => LocationModel(
                  name: address.name,
                  address: address.address,
                  latitude: address.latitude,
                  longitude: address.longitude,
                ))
            .toList();
        return Right(locations);
      } catch (e) {
        return const Left(NetworkFailure('No internet connection'));
      }
    }
  }

  @override
  Future<Either<Failure, List<SavedAddress>>> getSavedAddresses() async {
    if (await networkInfo.isConnected) {
      try {
        final addresses = await remoteDataSource.getSavedAddresses();
        await localDataSource.cacheSavedAddresses(addresses);
        return Right(addresses);
      } on ServerException catch (e) {
        // Try to return cached data on error
        try {
          final cachedAddresses = await localDataSource.getCachedSavedAddresses();
          return Right(cachedAddresses);
        } catch (_) {
          return Left(ServerFailure(e.message));
        }
      } on NetworkException catch (e) {
        // Try to return cached data on network error
        try {
          final cachedAddresses = await localDataSource.getCachedSavedAddresses();
          return Right(cachedAddresses);
        } catch (_) {
          return Left(NetworkFailure(e.message));
        }
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Return cached data when offline
      try {
        final cachedAddresses = await localDataSource.getCachedSavedAddresses();
        return Right(cachedAddresses);
      } catch (e) {
        return const Left(NetworkFailure('No internet connection'));
      }
    }
  }

  @override
  Future<Either<Failure, SavedAddress>> saveAddress({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    String? type,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final savedAddress = await remoteDataSource.saveAddress(
          name: name,
          address: address,
          latitude: latitude,
          longitude: longitude,
          type: type,
        );
        // Refresh cached addresses
        final addresses = await remoteDataSource.getSavedAddresses();
        await localDataSource.cacheSavedAddresses(addresses);
        return Right(savedAddress);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSavedAddress(int addressId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteSavedAddress(addressId);
        // Refresh cached addresses
        final addresses = await remoteDataSource.getSavedAddresses();
        await localDataSource.cacheSavedAddresses(addresses);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}

