import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/usecases/getAllOrders_usecase.dart';
import 'package:hatley/presentation/cubit/order_cubit/order_state.dart';

class GetAllOrdersCubit extends Cubit<OrderState> {
  GetallordersUseCase getAllOrdersUseCase;
  GetAllOrdersCubit(this.getAllOrdersUseCase) : super(OrderInitial());

  Future<void> getAllOrders() async {
    emit(OrderLoading());
    final result = await getAllOrdersUseCase.call();
    return result.fold(
      (failure) => emit(OrderFailure(failure.message)),
      (success) => emit(GetAllOrdersSuccess(success)),
    );
  }
}
