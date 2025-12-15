import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/location_model.dart';
import '../models/saved_address_model.dart';

abstract class LocationRemoteDataSource {
  Future<List<LocationModel>> searchLocations(String query);
  Future<List<LocationModel>> getRecentDestinations();
  Future<List<SavedAddressModel>> getSavedAddresses();
  Future<SavedAddressModel> saveAddress({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    String? type,
  });
  Future<void> deleteSavedAddress(int addressId);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final ApiClient apiClient;

  LocationRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<LocationModel>> searchLocations(String query) async {
    try {
      final response = await apiClient.post(
        '/locations/search',
        data: {'query': query},
      );

      if (response is List) {
        return (response as List)
            .map((json) => LocationModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<LocationModel>> getRecentDestinations() async {
    try {
      final response = await apiClient.get('/locations/recent');

      if (response is List) {
        return (response as List)
            .map((json) => LocationModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SavedAddressModel>> getSavedAddresses() async {
    try {
      final response = await apiClient.get('/locations/saved');

      if (response is List) {
        return (response as List)
            .map((json) => SavedAddressModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<SavedAddressModel> saveAddress({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    String? type,
  }) async {
    try {
      final response = await apiClient.post(
        '/locations/save',
        data: {
          'name': name,
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
          if (type != null) 'type': type,
        },
      );

      return SavedAddressModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteSavedAddress(int addressId) async {
    try {
      await apiClient.delete('/locations/saved/$addressId');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}

