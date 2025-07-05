import 'package:dio/dio.dart';
import 'package:hatley/data/model/review_response.dart';

abstract class ReviewDatasource {
  Future<void> addReview(int orderId, String review); //body
  Future<ReviewResponse> getReviewById(int orderId); //path
  Future<void> updateReview(int orderId, String review); //path
}

class ReviewDataSourceImpl implements ReviewDatasource {
  Dio dio;
  ReviewDataSourceImpl(this.dio);
  @override
  Future<void> addReview(int orderId, String review) async {
    final response = await dio.post(
      'Comment',
      data: {'order_id': orderId, 'text': review},
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add review');
    }
  }

  @override
  Future<ReviewResponse> getReviewById(int orderId) async {
    final response = await dio.get('Comment/orderid/$orderId');
    if (response.statusCode == 200) {
      final reviewResponse = ReviewResponse.fromJson(response.data);
      return reviewResponse;
    } else {
      throw Exception('Failed to fetch review');
    }
  }

  @override
  Future<void> updateReview(int orderId, String review) async {
    final response = await dio.put('Comment/$orderId/$review');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update review');
    }
  }
}
