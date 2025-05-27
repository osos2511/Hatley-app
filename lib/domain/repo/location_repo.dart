import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/governorate_entity.dart';

abstract class LocationRepo{
  Future<Either<Failure,List<GovernorateEntity>>> getAllGovernorate();
}