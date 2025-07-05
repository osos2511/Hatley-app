import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/review_entity.dart';

abstract class ReviewRepo {
  Future<Either<Failure, void>> addReview(int orderId, String review);
  Future<Either<Failure, ReviewEntity>> getReviewById(int orderId);
  Future<Either<Failure, void>> updateReview(int orderId, String review);
}
