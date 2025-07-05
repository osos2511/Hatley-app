import 'package:dio/dio.dart';
import 'package:hatley/data/model/deliveries_response.dart';

abstract class DeliveriesDataSource {
  Future<List<DeliveriesResponse>> getAllDeliveries();
}

class DeliveriesDataSourceImpl implements DeliveriesDataSource {
  final Dio dio;
  DeliveriesDataSourceImpl(this.dio);

  @override
  Future<List<DeliveriesResponse>> getAllDeliveries() async {
    try {
      final response = await dio.get('Order/Deliveries');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => DeliveriesResponse.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load deliveries');
      }
    } catch (e) {
      throw Exception('Error fetching deliveries: $e');
    }
  }
}
