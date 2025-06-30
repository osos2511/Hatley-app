import 'package:dio/dio.dart';

abstract class DeleteOrderRemoteDataSource {
  Future<void> deleteOrder(int orderId);
}

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
