import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/governorate_entity.dart';
import 'package:hatley/domain/entities/zone_entity.dart';

abstract class LocationRepo{
  Future<Either<Failure,List<GovernorateEntity>>> getAllGovernorate();
  Future<Either<Failure,List<ZoneEntity>>> getAllZoneByGovName({required String govName});
}