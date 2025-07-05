import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/data/datasources/review_datasource.dart';
import 'package:hatley/data/mappers/review_mapper.dart';
import 'package:hatley/domain/entities/review_entity.dart';
import 'package:hatley/domain/repo/review_repo.dart';

class ReviewRepoImpl implements ReviewRepo {
  ReviewDatasource reviewDatasource;
  ReviewRepoImpl(this.reviewDatasource);
  @override
  Future<Either<Failure, void>> addReview(int orderId, String review) async {
    try {
      await reviewDatasource.addReview(orderId, review);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> getReviewById(int orderId) async {
    try {
      final response = await reviewDatasource.getReviewById(orderId);
      final reviewEntity = response.toEntity();
      return Right(reviewEntity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateReview(int orderId, String review) async {
    try {
      await reviewDatasource.updateReview(orderId, review);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
