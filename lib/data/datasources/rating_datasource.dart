import 'package:dio/dio.dart';
import 'package:hatley/data/model/rating_response.dart';

abstract class RatingDataSource {
  Future<void> addRating(int orderId, int rating);
  Future<RatingResponse> getRatingById(int orderId);
  Future<void> updateRating(int orderId, int rating);
}

class RatingDataSourceImpl implements RatingDataSource {
  Dio dio;
  RatingDataSourceImpl(this.dio);
  @override
  Future<void> addRating(int orderId, int rating) async {
    final response = await dio.post(
      'Rating',
      queryParameters: {'orderid': orderId, 'value': rating},
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add rating');
    }
  }

  @override
  Future<RatingResponse> getRatingById(int orderId) async {
    final response = await dio.get('Rating/$orderId');
    if (response.statusCode == 200) {
      return RatingResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch rating');
    }
  }

  @override
  Future<void> updateRating(int orderId, int rating) async {
    final response = await dio.put('Rating/$orderId/$rating');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update rating');
    }
  }
}
