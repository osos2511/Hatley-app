import 'package:dio/dio.dart';
import 'package:hatley/data/datasources/deleteOrder_datasource/delete_order_remote_datasource.dart';

class DeleteOrderDatasourceImpl implements DeleteOrderRemoteDataSource {
  final Dio dio;
  DeleteOrderDatasourceImpl({required this.dio});
  @override
  Future<void> deleteOrder(int orderId) async {
    try {
      final response = await dio.delete('/Order/$orderId');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else {
        throw Exception('Failed to delete order: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete order: ${e.message}');
    }
  }
}
