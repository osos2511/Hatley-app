import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/review_entity.dart';
import 'package:hatley/domain/repo/review_repo.dart';

class ReviewUsecase {
  final ReviewRepo reviewRepo;

  ReviewUsecase(this.reviewRepo);

  Future<Either<Failure, void>> addReview(int orderId, String review) {
    return reviewRepo.addReview(orderId, review);
  }

  Future<Either<Failure, ReviewEntity>> getReviewById(int orderId) {
    return reviewRepo.getReviewById(orderId);
  }

  Future<Either<Failure, void>> updateReview(int orderId, String review) {
    return reviewRepo.updateReview(orderId, review);
  }
}
