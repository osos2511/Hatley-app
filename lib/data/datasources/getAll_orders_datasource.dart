import 'package:dio/dio.dart';
import 'package:hatley/data/model/order_model.dart';

abstract class GetAllOrdersRemoteDataSource {
  Future<List<OrderModel>> getAllOrders();
}

class GetallOrdersDatasourceImpl implements GetAllOrdersRemoteDataSource {
  final Dio dio;
  GetallOrdersDatasourceImpl({required this.dio});

  @override
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final response = await dio.get('Order/Orders');
      if (response.statusCode == 200 || response.statusCode == 201) {
        // إذا كانت الاستجابة 200/201 ولكن البيانات فارغة، فهذا جيد
        final data = response.data;
        if (data == null || (data is List && data.isEmpty)) {
          return []; // إذا كانت البيانات فارغة أو null، أعد قائمة فارغة
        }
        return (data as List).map((e) => OrderModel.fromJson(e)).toList();
      } else {
        // للتعامل مع أي رمز حالة آخر غير 200/201
        throw Exception('Failed to fetch orders with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // **** التعديل الرئيسي هنا للتعامل مع 400 "No Records exist" ****
      if (e.response?.statusCode == 400 && e.response?.data == "No Records exist") {
        // إذا كان الخطأ 400 وكانت الرسالة "No Records exist"، فهذا ليس خطأ حقيقي من منظور بيانات المستخدم
        // بل يعني أن لا توجد بيانات. لذا نعيد قائمة فارغة.
        return [];
      }
      // لأي خطأ DioException آخر، قم برمي الاستثناء كخطأ شبكة
      throw Exception('Network error: ${e.message}');
    }
  }
}