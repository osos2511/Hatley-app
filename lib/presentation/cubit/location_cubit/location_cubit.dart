import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/usecases/getAllGovernorate_usecase.dart';
import 'package:hatley/presentation/cubit/location_cubit/location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final GetAllGovernorateUseCase getAllGovernorateUseCase;
  LocationCubit(this.getAllGovernorateUseCase) : super(LocationInitial());
  Future<void> fetchGovernorates() async {
    emit(LocationLoading());
    final result = await getAllGovernorateUseCase.call();

    result.fold(
      (failure) {
        print('fetch Governorates failed: ${failure.message}');
        emit(LocationError(failure.message));
      },

      (governorates) {
        print('fetch Governorates success: $governorates');
        emit(LocationLoaded(governorates));
      },
    );
  }
}
