import 'package:dio/dio.dart';
import 'package:hatley/data/datasources/addOrder_datasource/add_order_remote_datasource.dart';

class AddOrderDatasourceImpl implements AddOrderRemoteDatasource {
  final Dio dio;

  AddOrderDatasourceImpl({required this.dio});

  @override
  Future<void> addOrder({
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
    try {
      final response = await dio.post(
        '/Order',
        data: {
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
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception('Failed to add order: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to add order: ${e.message}');
    }
  }
}
