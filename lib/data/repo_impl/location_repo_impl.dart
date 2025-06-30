import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/data/datasources/get_all_governorate_datasource.dart';
import 'package:hatley/data/datasources/get_all_zoneBy_gov_name_datasource.dart';
import 'package:hatley/domain/entities/governorate_entity.dart';
import 'package:hatley/domain/entities/zone_entity.dart';
import 'package:hatley/domain/repo/location_repo.dart';

class LocationRepoImpl implements LocationRepo {
  GetAllGovernorateRemoteDataSource remoteDataSource;
  GetAllZoneByGovNameRemoteDataSource zoneRemoteDataSource;
  LocationRepoImpl(this.remoteDataSource, this.zoneRemoteDataSource);
  @override
  Future<Either<Failure, List<GovernorateEntity>>> getAllGovernorate() async {
    try {
      final result = await remoteDataSource.getAllGovernorate();
      final entityList = result.map((e) => e.toEntity()).toList();
      return Right(entityList);
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ZoneEntity>>> getAllZoneByGovName({
    required String govName,
  }) async {
    try {
      final result = await zoneRemoteDataSource.getAllZoneByGovName(
        govName: govName,
      );
      final entityList = result.map((e) => e.toEntity()).toList();
      return Right(entityList);
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
