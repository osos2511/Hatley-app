import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/data/datasources/addOrder_datasource/add_order_remote_datasource.dart';
import 'package:hatley/domain/repo/order_repo.dart';

class OrderRepoImpl implements OrderRepo {
  AddOrderRemoteDatasource addOrderRemoteDatasource;
  OrderRepoImpl(this.addOrderRemoteDatasource);
  @override
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
  }) async {
    try {
      await addOrderRemoteDatasource.addOrder(
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
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
