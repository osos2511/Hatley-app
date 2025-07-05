import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/data/datasources/rating_datasource.dart';
import 'package:hatley/domain/entities/rating_entity.dart';

abstract class RatingRepo {
  RatingDataSource ratingDataSource;
  RatingRepo(this.ratingDataSource);
  Future<Either<Failure, void>> addRating(int orderId, int rating);
  Future<Either<Failure, RatingEntity>> getRatingById(int orderId);
  Future<Either<Failure, void>> updateRating(int orderId, int rating);
}
