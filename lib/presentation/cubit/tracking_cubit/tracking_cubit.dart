import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/data/model/traking_response.dart';
import 'tracking_state.dart';
import '../../../core/api_manager/api_manager.dart';
import '../../../core/error/failure.dart';

class TrackingCubit extends Cubit<TrackingState> {
  final TrakingApiManager trakingApiManager;

  TrackingCubit({required this.trakingApiManager}) : super(TrackingInitial());

  Future<void> getTrackingData([int? orderId]) async {
    emit(TrackingLoading());
    final result = await trakingApiManager.getAllTrackingData();

    result.fold(
      (failure) {
        String errorMessage;
        if (failure is ServerFailure) {
          errorMessage = 'Server Error: ${failure.message}';
        } else if (failure is NetworkFailure) {
          errorMessage = 'Network Error: ${failure.message}';
        } else {
          errorMessage = 'An unknown error occurred: ${failure.message}';
        }
        emit(TrackingError(message: errorMessage));
      },
      (allTrackingData) {
        if (allTrackingData.isNotEmpty) {
          emit(TrackingLoaded(trackingData: allTrackingData));
        } else {
          emit(TrackingError(message: 'No tracking orders found.'));
        }
      },
    );
  }

  // دالة updateOrderStatus تبقى كما هي بدون تغيير
  void updateOrderStatus({
    required int orderId,
    required int newStatus,
    required String userEmail,
    required String userType,
  }) {
    if (state is TrackingLoaded) {
      final currentState = state as TrackingLoaded;
      final List<TrakingResponse> currentOrders = List.from(
        currentState.trackingData,
      );

      final int index = currentOrders.indexWhere(
        (order) => order.orderId == orderId,
      );

      if (index != -1) {
        final TrakingResponse oldOrder = currentOrders[index];
        final TrakingResponse updatedOrder = oldOrder.copyWith(
          status: newStatus,
        );

        currentOrders[index] = updatedOrder;
        emit(TrackingLoaded(trackingData: currentOrders));
        print('Cubit: Order $orderId status updated to $newStatus');
      } else {
        print(
          'Cubit: Order $orderId not found in current tracking list. Cannot update.',
        );
      }
    } else {
      print(
        'Cubit: Cannot update order status, current state is not TrackingLoaded. Ignoring update.',
      );
    }
  }
}
