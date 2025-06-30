import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/data/datasources/offer_datasource.dart';
import 'package:hatley/domain/repo/offer_repo.dart';

class OfferRepoImpl implements OfferRepo {
  OfferDataSource offerDataSource;

  OfferRepoImpl(this.offerDataSource);
  @override
  Future<Either<Failure, void>> acceptOffer(
    int orderId,
    int priceOffer,
    String deliveryEmail,
  ) async {
    try {
      final result = await offerDataSource.acceptOffer(
        orderId,
        priceOffer,
        deliveryEmail,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> declineOffer(
    int orderId,
    int priceOffer,
    String deliveryEmail,
  ) async {
    try {
      final result = await offerDataSource.declineOffer(
        orderId,
        priceOffer,
        deliveryEmail,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
