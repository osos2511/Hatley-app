import 'package:dio/dio.dart';
import 'package:hatley/data/datasources/getAllOrders_datasource/getAll_orders_remote_datasource.dart';
import 'package:hatley/data/model/order_model.dart';

class GetallOrdersDatasourceImpl implements GetAllOrdersRemoteDataSource {
  final Dio dio;
  GetallOrdersDatasourceImpl({required this.dio});
  @override
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final response = await dio.get('Order');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List;
        return data.map((e) => OrderModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch orders: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
