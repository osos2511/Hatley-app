import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/usecases/editOrder_usecase.dart';
import 'package:hatley/presentation/cubit/order_cubit/order_state.dart';

class EditOrderCubit extends Cubit<OrderState> {
  EditOrderUseCase editOrderUseCase;
  EditOrderCubit(this.editOrderUseCase) : super(OrderInitial());
  Future<void> editOrder({
    required int orderId,
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
    final result = await editOrderUseCase.call(
      orderId: orderId,
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
