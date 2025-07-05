import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/rating_entity.dart';
import 'package:hatley/domain/repo/rating_repo.dart';

class RatingUsecase {
  final RatingRepo ratingRepo;

  RatingUsecase(this.ratingRepo);

  Future<Either<Failure, void>> addRating(int orderId, int rating) {
    return ratingRepo.addRating(orderId, rating);
  }

  Future<Either<Failure, RatingEntity>> getRatingById(int orderId) {
    return ratingRepo.getRatingById(orderId);
  }

  Future<Either<Failure, void>> updateRating(int orderId, int rating) {
    return ratingRepo.updateRating(orderId, rating);
  }
}
