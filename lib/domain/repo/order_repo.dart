import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';

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
}
