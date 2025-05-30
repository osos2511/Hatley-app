import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/entities/order_entity.dart';
import 'package:hatley/domain/usecases/getAllOrders_usecase.dart';
import 'package:hatley/presentation/cubit/order_cubit/order_state.dart';

class GetAllOrdersCubit extends Cubit<OrderState> {
  List<OrderEntity> orders = [];

  final GetallordersUseCase getAllOrdersUseCase;

  GetAllOrdersCubit(this.getAllOrdersUseCase) : super(OrderInitial());

  Future<void> getAllOrders() async {
    emit(OrderLoading());
    final result = await getAllOrdersUseCase.call();
    result.fold((failure) => emit(OrderFailure(failure.message)), (success) {
      orders = success;
      emit(GetAllOrdersSuccess(orders));
    });
  }

  void removeOrderById(int id) {
    orders.removeWhere((order) => order.orderId == id);
    emit(GetAllOrdersSuccess(List.from(orders)));
  }
}
