class DeliveriesResponse {
  final int orderId;
  final int? orderRate;
  final String description;
  final String orderGovernorateFrom;
  final String orderZoneFrom;
  final String orderCityFrom;
  final String detailesAddressFrom;
  final String orderGovernorateTo;
  final String orderZoneTo;
  final String orderCityTo;
  final String detailesAddressTo;
  final DateTime created;
  final DateTime orderTime;
  final double price;
  final int status;
  final String deliveryName;
  final String? deliveryPhoto;
  final double deliveryAvgRate;

  DeliveriesResponse({
    required this.orderId,
    required this.orderRate,
    required this.description,
    required this.orderGovernorateFrom,
    required this.orderZoneFrom,
    required this.orderCityFrom,
    required this.detailesAddressFrom,
    required this.orderGovernorateTo,
    required this.orderZoneTo,
    required this.orderCityTo,
    required this.detailesAddressTo,
    required this.created,
    required this.orderTime,
    required this.price,
    required this.status,
    required this.deliveryName,
    required this.deliveryPhoto,
    required this.deliveryAvgRate,
  });

  factory DeliveriesResponse.fromJson(Map<String, dynamic> json) {
    return DeliveriesResponse(
      orderId: json['order_id'] as int,
      orderRate: json['order_rate'] as int?,
      description: json['description'] as String,
      orderGovernorateFrom: json['order_governorate_from'] as String,
      orderZoneFrom: json['order_zone_from'] as String,
      orderCityFrom: json['order_city_from'] as String,
      detailesAddressFrom: json['detailes_address_from'] as String,
      orderGovernorateTo: json['order_governorate_to'] as String,
      orderZoneTo: json['order_zone_to'] as String,
      orderCityTo: json['order_city_to'] as String,
      detailesAddressTo: json['detailes_address_to'] as String,
      created: DateTime.parse(json['created'] as String),
      orderTime: DateTime.parse(json['order_time'] as String),
      price: (json['price'] as num).toDouble(),
      status: json['status'] as int,
      deliveryName: json['delivery_name'] as String,
      deliveryPhoto: json['delivery_photo'] as String?,
      deliveryAvgRate: (json['delivery_avg_rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'order_rate': orderRate,
      'description': description,
      'order_governorate_from': orderGovernorateFrom,
      'order_zone_from': orderZoneFrom,
      'order_city_from': orderCityFrom,
      'detailes_address_from': detailesAddressFrom,
      'order_governorate_to': orderGovernorateTo,
      'order_zone_to': orderZoneTo,
      'order_city_to': orderCityTo,
      'detailes_address_to': detailesAddressTo,
      'created': created.toIso8601String(),
      'order_time': orderTime.toIso8601String(),
      'price': price,
      'status': status,
      'delivery_name': deliveryName,
      'delivery_photo': deliveryPhoto,
      'delivery_avg_rate': deliveryAvgRate,
    };
  }
}
