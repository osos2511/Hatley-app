import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/data/datasources/acceptOffer_datasource/accept_offer_datasource.dart';
import 'package:hatley/domain/repo/offer_repo.dart';

class OfferRepoImpl implements OfferRepo{
  AcceptOfferDataSource acceptOfferDataSource;
  OfferRepoImpl( this.acceptOfferDataSource);
  @override
  Future<Either<Failure, void>> acceptOffer(int orderId, int priceOffer, String deliveryEmail) async{
    try{
      final result=await acceptOfferDataSource.acceptOffer(orderId, priceOffer, deliveryEmail);
      return Right(result);

    }catch(e){
      return Left(ServerFailure(e.toString()));
    }
  }

}