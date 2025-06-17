import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/repo/order_repo.dart';

class EditOrderUseCase {
  OrderRepo orderRepo;
  EditOrderUseCase(this.orderRepo);
  Future<Either<Failure, void>> call({
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
    return await orderRepo.editOrder(
      orderId: orderId,
      description: description,
      orderGovernorateFrom: orderGovernorateFrom,
      orderZoneFrom: orderZoneFrom,
      orderCityFrom: orderCityFrom,
      detailesAddressFrom: detailesAddressFrom,
      orderGovernorateTo: orderGovernorateTo,
      orderZoneTo: orderZoneTo,
      orderCityTo: orderCityTo,
      detailesAddressTo: detailesAddressTo,
      orderTime: orderTime,
      price: price,
    );
  }
}
