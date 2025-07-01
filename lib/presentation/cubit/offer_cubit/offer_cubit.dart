// OfferCubit.dart (المعدل بناءً على offer_state الجديد)
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/usecases/acceptOffer_usecase.dart';
import 'package:hatley/domain/usecases/declineOffer_usecase.dart';
import 'package:hatley/presentation/cubit/offer_cubit/offer_state.dart';

class OfferCubit extends Cubit<OfferState> {
  AcceptOfferUseCase acceptOfferUseCase;
  DeclineofferUsecase declineOfferUsecase;

  OfferCubit(this.acceptOfferUseCase, this.declineOfferUsecase)
      : super(OfferInitial());

  Future<void> acceptOffer(
      int orderId,
      int offerPrice,
      String deliveryEmail,
      ) async {
    emit(OfferLoading());
    final result = await acceptOfferUseCase.call(
      orderId,
      offerPrice,
      deliveryEmail,
    );
    result.fold(
          (failure) => emit(OfferFailure(failure.message)),
          (_) => emit(OfferAcceptedSuccess(orderId: orderId)), // **** تم التعديل هنا ****
    );
  }

  Future<void> declineOffer(
      int orderId,
      int offerPrice,
      String deliveryEmail,
      ) async {
    emit(OfferLoading());
    final result = await declineOfferUsecase.call(
      orderId,
      offerPrice,
      deliveryEmail,
    );
    result.fold(
          (failure) => emit(OfferFailure(failure.message)),
          (_) => emit(OfferDeclinedSuccess("Offer declined successfully!")), // **** تم التعديل هنا ****
    );
  }
}