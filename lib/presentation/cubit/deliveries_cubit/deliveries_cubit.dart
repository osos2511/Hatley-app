import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/usecases/get_deliveries_usecase.dart';
import 'package:hatley/presentation/cubit/deliveries_cubit/deliveries_state.dart';

class DeliveriesCubit extends Cubit<DeliveriesState> {
  GetDeliveriesUsecase getDeliveriesUsecase;
  DeliveriesCubit(this.getDeliveriesUsecase) : super(DeliveriesInitial());

  Future<void> getAllDeliveries() async {
    emit(DeliveriesLoading());
    final result = await getDeliveriesUsecase.call();
    result.fold(
      (failure) => emit(DeliveriesError(failure.message)),
      (deliveries) => emit(DeliveriesLoaded(deliveries)),
    );
  }
}
