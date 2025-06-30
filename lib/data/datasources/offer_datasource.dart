import 'package:dio/dio.dart';

abstract class OfferDataSource {
  Future<void> acceptOffer(int orderId, int priceOffer, String deliveryEmail);
  Future<void> declineOffer(int orderId, int priceOffer, String deliveryEmail);
}

class OfferDataSourceImpl implements OfferDataSource {
  final Dio dio;
  OfferDataSourceImpl({required this.dio});
  @override
  Future<void> acceptOffer(
    int orderId,
    int priceOffer,
    String deliveryEmail,
  ) async {
    try {
      final response = await dio.get(
        '/Offer/User/Accept',
        queryParameters: {
          'orderid': orderId,
          'delivery_email': deliveryEmail,
          'price_of_offer': priceOffer,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else {
        throw Exception('Failed to accept offer: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to accept offer: ${e.message}');
    }
  }

  @override
  Future<void> declineOffer(
    int orderId,
    int priceOffer,
    String deliveryEmail,
  ) async {
    try {
      final response = await dio.get(
        '/Offer/User/Decline',
        queryParameters: {
          'orderid': orderId,
          'delivery_email': deliveryEmail,
          'price_of_offer': priceOffer,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else {
        throw Exception('Failed to decline offer: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to decline offer: ${e.message}');
    }
  }
}
