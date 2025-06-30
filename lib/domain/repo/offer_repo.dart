import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';

abstract class OfferRepo {
  Future<Either<Failure, void>> acceptOffer(
    int orderId,
    int priceOffer,
    String deliveryEmail,
  );
  Future<Either<Failure, void>> declineOffer(
    int orderId,
    int priceOffer,
    String deliveryEmail,
  );
}
