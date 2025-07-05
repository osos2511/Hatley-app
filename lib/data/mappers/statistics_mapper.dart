import 'package:hatley/data/model/statistics_response.dart';
import 'package:hatley/domain/entities/statistics_entity.dart';

extension StatisticsMapper on StatisticsResponse {
  StatisticsEntity toEntity() {
    return StatisticsEntity(
      totalOrders: totalOrders,
      completeOrders: completeOrders,
      incompleteOrders: incompleteOrders,
      pending: pending,
      ordersLast30Days: ordersLast30Days,
      rate: rate,
    );
  }
}
