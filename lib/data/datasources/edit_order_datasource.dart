import 'package:dio/dio.dart';

abstract class EditOrderRemoteDataSource {
  Future<void> editOrder({
    required int orderId,
    required String description,
    required String orderGovernorateFrom,
    required String orderZoneFrom,
    required String orderCityFrom,
    required String detailesAddressFrom,
    required String orderGovernorateTo,
    required String orderZoneTo,
    required String orderCityTo,
    required String detailesAddressTo,
    required DateTime orderTime,
    required num price,
  });
}

class EditOrderDatasourceImpl implements EditOrderRemoteDataSource {
  final Dio dio;
  EditOrderDatasourceImpl({required this.dio});
  @override
  Future<void> editOrder({
    required int orderId,
    required String description,
    required String orderGovernorateFrom,
    required String orderZoneFrom,
    required String orderCityFrom,
    required String detailesAddressFrom,
    required String orderGovernorateTo,
    required String orderZoneTo,
    required String orderCityTo,
    required String detailesAddressTo,
    required DateTime orderTime,
    required num price,
  }) async {
    final requestData = {
      'description': description,
      'order_governorate_from': orderGovernorateFrom,
      'order_zone_from': orderZoneFrom,
      'order_city_from': orderCityFrom,
      'detailes_address_from': detailesAddressFrom,
      'order_governorate_to': orderGovernorateTo,
      'order_zone_to': orderZoneTo,
      'order_city_to': orderCityTo,
      'detailes_address_to': detailesAddressTo,
      'order_time': orderTime.toIso8601String(),
      'price': price,
    };

    print("📤 Sending PUT request to Order/$orderId with:");
    requestData.forEach((key, value) => print('$key: $value'));

    try {
      final response = await dio.put('Order/$orderId', data: requestData);

      print("📥 Status Code: ${response.statusCode}");
      print("✅ Response: ${response.data ?? 'No response body'}");

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return;
      } else {
        throw Exception('⚠️ Failed to update order: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("❌ DioException: ${e.message}");
      print("📬 Dio Response Data: ${e.response?.data}");
      print("🔗 Status Code: ${e.response?.statusCode}");

      throw Exception(
        '❌ Failed to update order: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      print("❗ General Exception: $e");
      rethrow;
    }
  }
}
