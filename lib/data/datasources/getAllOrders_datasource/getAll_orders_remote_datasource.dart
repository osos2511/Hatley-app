import 'package:hatley/data/model/order_model.dart';

abstract class GetAllOrdersRemoteDataSource {
  Future<List<OrderModel>> getAllOrders();
}
