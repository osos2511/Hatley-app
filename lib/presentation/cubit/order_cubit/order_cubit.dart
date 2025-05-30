import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/usecases/addOrder_usecase.dart';
import 'package:hatley/presentation/cubit/order_cubit/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  AddorderUsecase addOrderUsecase;

  OrderCubit(this.addOrderUsecase) : super(OrderInitial());

  Future<void> addOrder({
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
  }) async {
    emit(OrderLoading());
    final result = await addOrderUsecase.call(
      description: description,
      orderGovernorateFrom: orderGovernorateFrom,
      orderZoneFrom: orderZoneFrom,
      orderCityFrom: orderCityFrom,
      detailesAddressFrom: detailesAddressFrom,
      orderGovernorateTo: orderGovernorateTo,
      orderZoneTo: orderZoneTo,
      orderCityTo: orderCityTo,
      detailesAddressTo: detailesAddressTo,
      orderTime: orderTime,
      price: price,
    );
    return result.fold(
      (failure) => emit(OrderFailure(failure.message)),
      (_) => emit(OrderSuccess()),
    );
  }
}
