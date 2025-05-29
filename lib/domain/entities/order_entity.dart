class OrderEntity {
  final String description;
  final String orderGovernorateFrom;
  final String orderZoneFrom;
  final String orderCityFrom;
  final String detailesAddressFrom;
  final String orderGovernorateTo;
  final String orderZoneTo;
  final String orderCityTo;
  final String detailesAddressTo;
  final num price;
  final DateTime orderTime;

  OrderEntity({
    required this.description,
    required this.detailesAddressFrom,
    required this.detailesAddressTo,
    required this.orderCityFrom,
    required this.orderCityTo,
    required this.orderGovernorateFrom,
    required this.orderGovernorateTo,
    required this.orderTime,
    required this.orderZoneFrom,
    required this.orderZoneTo,
    required this.price,
  });
}
