import 'package:dartz/dartz.dart';
import 'package:hatley/domain/repo/offer_repo.dart';

import '../../core/error/failure.dart';

class AcceptOfferUseCase{
  OfferRepo acceptOfferUseCase;
  AcceptOfferUseCase(this.acceptOfferUseCase);
  Future<Either<Failure, void>> call(int orderId,int offerPrice,String deliveryEmail) {
    return acceptOfferUseCase.acceptOffer(orderId,offerPrice,deliveryEmail);
  }
}