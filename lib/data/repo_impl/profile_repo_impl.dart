import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/data/datasources/profile_datasource.dart';
import 'package:hatley/data/mappers/profile_mapper.dart';
import 'package:hatley/domain/entities/profile_entity.dart';
import 'package:hatley/domain/repo/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  ProfileDatasource profileDatasource;
  ProfileRepoImpl(this.profileDatasource);

  @override
  Future<Either<Failure, ProfileEntity>> getProfileInfo() async {
    try {
      final profileResponse = await profileDatasource.getProfileInfo();
      final profileEntity = profileResponse.toEntity();
      return Right(profileEntity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(File imagePath) async {
    try {
      final imageUrl = await profileDatasource.uploadProfileImage(imagePath);
      return Right(imageUrl);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
