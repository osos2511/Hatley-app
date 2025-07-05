class ReviewResponse {
  final int id;
  final String text;
  final DateTime createdAt;
  final int orderId;
  final int deliveryId;

  ReviewResponse({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.orderId,
    required this.deliveryId,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      id: json['id'] as int,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      orderId: json['order_id'] as int,
      deliveryId: json['delivery_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'order_id': orderId,
      'delivery_id': deliveryId,
    };
  }
}
