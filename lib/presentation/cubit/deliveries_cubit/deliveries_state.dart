import 'package:hatley/domain/entities/deliveries_entity.dart';

abstract class DeliveriesState {}

class DeliveriesInitial extends DeliveriesState {}

class DeliveriesLoading extends DeliveriesState {}

class DeliveriesLoaded extends DeliveriesState {
  final List<DeliveriesEntity> deliveries;

  DeliveriesLoaded(this.deliveries);
}

class DeliveriesError extends DeliveriesState {
  final String message;

  DeliveriesError(this.message);
}
