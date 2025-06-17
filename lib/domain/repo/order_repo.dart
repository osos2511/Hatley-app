import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/order_entity.dart';

abstract class OrderRepo {
  Future<Either<Failure, void>> addOrder({
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
  Future<Either<Failure, List<OrderEntity>>> getAllOrders();

  Future<Either<Failure, void>> deleteOrder(int orderId);

  Future<Either<Failure, void>> editOrder({
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
