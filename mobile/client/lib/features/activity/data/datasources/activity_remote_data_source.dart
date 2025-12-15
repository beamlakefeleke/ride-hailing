import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../rides/data/models/ride_model.dart';

abstract class ActivityRemoteDataSource {
  Future<List<RideModel>> getOngoingRides();
  Future<List<RideModel>> getScheduledRides();
  Future<List<RideModel>> getCompletedRides({int page = 0, int size = 20});
  Future<List<RideModel>> getCancelledRides({int page = 0, int size = 20});
}

class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  final ApiClient apiClient;

  ActivityRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<RideModel>> getOngoingRides() async {
    try {
      final response = await apiClient.get('/rides/ongoing');
      if (response is List) {
        return (response as List)
            .map((json) => RideModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RideModel>> getScheduledRides() async {
    try {
      final response = await apiClient.get('/rides/scheduled');
      if (response is List) {
        return (response as List)
            .map((json) => RideModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RideModel>> getCompletedRides({int page = 0, int size = 20}) async {
    try {
      final response = await apiClient.get(
        '/rides/history',
        queryParameters: {
          'page': page,
          'size': size,
          'status': 'COMPLETED',
        },
      );
      if (response is List) {
        return (response as List)
            .map((json) => RideModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RideModel>> getCancelledRides({int page = 0, int size = 20}) async {
    try {
      final response = await apiClient.get(
        '/rides/history',
        queryParameters: {
          'page': page,
          'size': size,
          'status': 'CANCELLED',
        },
      );
      if (response is List) {
        return (response as List)
            .map((json) => RideModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}

