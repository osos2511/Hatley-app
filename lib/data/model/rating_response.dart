class RatingResponse {
  final int ratingId;
  final int value;
  final DateTime createdAt;
  final String nameFrom;
  final String nameTo;
  final int orderId;
  final int deliveryId;
  final int userId;

  RatingResponse({
    required this.ratingId,
    required this.value,
    required this.createdAt,
    required this.nameFrom,
    required this.nameTo,
    required this.orderId,
    required this.deliveryId,
    required this.userId,
  });

  factory RatingResponse.fromJson(Map<String, dynamic> json) {
    return RatingResponse(
      ratingId: json['rating_id'] as int,
      value: json['value'] as int,
      createdAt: DateTime.parse(json['createdat']),
      nameFrom: json['name_from'] as String,
      nameTo: json['name_to'] as String,
      orderId: json['order_id'] as int,
      deliveryId: json['delivery_id'] as int,
      userId: json['user_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating_id': ratingId,
      'value': value,
      'createdat': createdAt.toIso8601String(),
      'name_from': nameFrom,
      'name_to': nameTo,
      'order_id': orderId,
      'delivery_id': deliveryId,
      'user_id': userId,
    };
  }
}
