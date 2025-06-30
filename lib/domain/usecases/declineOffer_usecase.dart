import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/repo/offer_repo.dart';

class DeclineofferUsecase {
  OfferRepo declineOfferUsecase;

  DeclineofferUsecase(this.declineOfferUsecase);

  Future<Either<Failure, void>> call(
    int orderId,
    int priceOffer,
    String deliveryEmail,
  ) {
    return declineOfferUsecase.declineOffer(orderId, priceOffer, deliveryEmail);
  }
}
