import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/price_estimate_model.dart';
import '../models/ride_model.dart';

abstract class RideRemoteDataSource {
  Future<PriceEstimateModel> estimatePrice({
    required double pickupLatitude,
    required double pickupLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    required String rideType,
  });

  Future<RideModel> bookRide({
    required double pickupLatitude,
    required double pickupLongitude,
    required String pickupAddress,
    required double destinationLatitude,
    required double destinationLongitude,
    required String destinationAddress,
    required String rideType,
    required double price,
    DateTime? scheduledDateTime,
  });

  Future<RideModel> getRide(int rideId);
  Future<List<RideModel>> getRideHistory({int page = 0, int size = 20});
  Future<RideModel> cancelRide(int rideId, {String? reason});
}

class RideRemoteDataSourceImpl implements RideRemoteDataSource {
  final ApiClient apiClient;

  RideRemoteDataSourceImpl(this.apiClient);

  @override
  Future<PriceEstimateModel> estimatePrice({
    required double pickupLatitude,
    required double pickupLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    required String rideType,
  }) async {
    try {
      final response = await apiClient.post(
        '/rides/estimate-price',
        data: {
          'pickupLatitude': pickupLatitude,
          'pickupLongitude': pickupLongitude,
          'destinationLatitude': destinationLatitude,
          'destinationLongitude': destinationLongitude,
          'rideType': rideType,
        },
      );

      return PriceEstimateModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RideModel> bookRide({
    required double pickupLatitude,
    required double pickupLongitude,
    required String pickupAddress,
    required double destinationLatitude,
    required double destinationLongitude,
    required String destinationAddress,
    required String rideType,
    required double price,
    DateTime? scheduledDateTime,
  }) async {
    try {
      final response = await apiClient.post(
        '/rides/book',
        data: {
          'pickupLatitude': pickupLatitude,
          'pickupLongitude': pickupLongitude,
          'pickupAddress': pickupAddress,
          'destinationLatitude': destinationLatitude,
          'destinationLongitude': destinationLongitude,
          'destinationAddress': destinationAddress,
          'rideType': rideType,
          'price': price,
          if (scheduledDateTime != null)
            'scheduledDateTime': scheduledDateTime.toIso8601String(),
        },
      );

      return RideModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RideModel> getRide(int rideId) async {
    try {
      final response = await apiClient.get('/rides/$rideId');
      return RideModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RideModel>> getRideHistory({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await apiClient.get(
        '/rides/history',
        queryParameters: {
          'page': page,
          'size': size,
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
  Future<RideModel> cancelRide(int rideId, {String? reason}) async {
    try {
      final response = await apiClient.post(
        '/rides/$rideId/cancel',
        data: reason != null ? {'reason': reason} : null,
      );

      return RideModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}

