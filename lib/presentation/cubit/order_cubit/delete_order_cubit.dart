import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/usecases/deleteOrder_usecase.dart';
import 'package:hatley/presentation/cubit/order_cubit/order_state.dart';

class DeleteOrderCubit extends Cubit<OrderState> {
  final DeleteOrderUsecase deleteOrderUsecase;

  DeleteOrderCubit(this.deleteOrderUsecase) : super(OrderInitial());

  Future<void> deleteOrder(int orderId) async {
    emit(OrderLoading());
    final result = await deleteOrderUsecase.call(orderId);
    result.fold(
      (failure) => emit(OrderFailure(failure.message)),
      (_) => emit(OrderSuccess()),
    );
  }
}
