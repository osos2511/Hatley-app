import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/data/datasources/rating_datasource.dart';
import 'package:hatley/data/mappers/rating_mappers.dart';
import 'package:hatley/domain/entities/rating_entity.dart';
import 'package:hatley/domain/repo/rating_repo.dart';

class RatingRepoImpl implements RatingRepo {
  RatingDataSource ratingDataSource;
  RatingRepoImpl(this.ratingDataSource);

  @override
  Future<Either<Failure, void>> addRating(int orderId, int rating) async {
    try {
      await ratingDataSource.addRating(orderId, rating);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RatingEntity>> getRatingById(int orderId) async {
    try {
      final response = await ratingDataSource.getRatingById(orderId);
      final ratingEntity = response.toEntity();
      return Right(ratingEntity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateRating(int orderId, int rating) async {
    try {
      await ratingDataSource.updateRating(orderId, rating);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
