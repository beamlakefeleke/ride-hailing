import '../../../../core/network/api_client.dart';
import '../models/ride_rating_model.dart';

abstract class RatingRemoteDataSource {
  Future<RideRatingModel> rateRide({
    required int rideId,
    required int rating,
    String? comment,
  });
  
  Future<RideRatingModel?> getRideRating(int rideId);
}

class RatingRemoteDataSourceImpl implements RatingRemoteDataSource {
  final ApiClient apiClient;

  RatingRemoteDataSourceImpl(this.apiClient);

  @override
  Future<RideRatingModel> rateRide({
    required int rideId,
    required int rating,
    String? comment,
  }) async {
    final response = await apiClient.post(
      '/api/ratings/rides/$rideId',
      data: {
        'rating': rating,
        if (comment != null) 'comment': comment,
      },
    );
    return RideRatingModel.fromJson(response);
  }

  @override
  Future<RideRatingModel?> getRideRating(int rideId) async {
    try {
      final response = await apiClient.get('/api/ratings/rides/$rideId');
      return RideRatingModel.fromJson(response);
    } catch (e) {
      // Rating not found
      return null;
    }
  }
}

