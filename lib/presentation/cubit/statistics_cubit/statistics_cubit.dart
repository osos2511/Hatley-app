import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/usecases/getAll_statistics_usecase.dart';
import 'package:hatley/presentation/cubit/statistics_cubit/statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  GetallStatisticsUsecase getallStatisticsUsecase;
  StatisticsCubit(this.getallStatisticsUsecase) : super(StatisticsInitial());
  Future<void> getAllStatistics() async {
    emit(StatisticsLoading());
    final result = await getallStatisticsUsecase();
    result.fold(
      (failure) => emit(StatisticsError(failure.message)),
      (statistics) => emit(StatisticsLoaded(statistics)),
    );
  }
}
