class OrderModel {
  OrderModel({
      this.orderId, 
      this.description, 
      this.orderGovernorateFrom, 
      this.orderZoneFrom, 
      this.orderCityFrom, 
      this.detailesAddressFrom, 
      this.orderGovernorateTo, 
      this.orderZoneTo, 
      this.orderCityTo, 
      this.detailesAddressTo, 
      this.north, 
      this.east, 
      this.created, 
      this.orderTime, 
      this.price, 
      this.status, 
      this.userID, 
      this.deliveryID,});

  OrderModel.fromJson(dynamic json) {
    orderId = json['order_id'];
    description = json['description'];
    orderGovernorateFrom = json['order_governorate_from'];
    orderZoneFrom = json['order_zone_from'];
    orderCityFrom = json['order_city_from'];
    detailesAddressFrom = json['detailes_address_from'];
    orderGovernorateTo = json['order_governorate_to'];
    orderZoneTo = json['order_zone_to'];
    orderCityTo = json['order_city_to'];
    detailesAddressTo = json['detailes_address_to'];
    north = json['north'];
    east = json['east'];
    created = json['created'];
    orderTime = json['order_time'];
    price = json['price'];
    status = json['status'];
    userID = json['user_ID'];
    deliveryID = json['delivery_ID'];
  }
  num? orderId;
  String? description;
  String? orderGovernorateFrom;
  String? orderZoneFrom;
  String? orderCityFrom;
  String? detailesAddressFrom;
  String? orderGovernorateTo;
  String? orderZoneTo;
  String? orderCityTo;
  String? detailesAddressTo;
  dynamic north;
  dynamic east;
  String? created;
  String? orderTime;
  num? price;
  num? status;
  num? userID;
  num? deliveryID;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = orderId;
    map['description'] = description;
    map['order_governorate_from'] = orderGovernorateFrom;
    map['order_zone_from'] = orderZoneFrom;
    map['order_city_from'] = orderCityFrom;
    map['detailes_address_from'] = detailesAddressFrom;
    map['order_governorate_to'] = orderGovernorateTo;
    map['order_zone_to'] = orderZoneTo;
    map['order_city_to'] = orderCityTo;
    map['detailes_address_to'] = detailesAddressTo;
    map['north'] = north;
    map['east'] = east;
    map['created'] = created;
    map['order_time'] = orderTime;
    map['price'] = price;
    map['status'] = status;
    map['user_ID'] = userID;
    map['delivery_ID'] = deliveryID;
    return map;
  }

}