import 'package:hatley/domain/entities/order_entity.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {}

class GetAllOrdersSuccess extends OrderState {
  final List<OrderEntity> orders; // Replace dynamic with your order model
  GetAllOrdersSuccess(this.orders);
}

class OrderFailure extends OrderState {
  final String error;
  OrderFailure(this.error);
}
