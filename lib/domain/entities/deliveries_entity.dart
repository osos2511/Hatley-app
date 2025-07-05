class DeliveriesEntity {
  final int orderId;
  final int? orderRate;
  final String description;
  final String orderCityFrom;
  final String orderCityTo;
  final DateTime created;
  final double price;
  final int status;
  final String deliveryName;

  DeliveriesEntity({
    required this.orderId,
    required this.orderRate,
    required this.description,
    required this.orderCityFrom,
    required this.orderCityTo,
    required this.created,
    required this.price,
    required this.status,
    required this.deliveryName,
  });
}
