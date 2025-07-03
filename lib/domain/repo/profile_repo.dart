import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/profile_entity.dart';

abstract class ProfileRepo {
  Future<Either<Failure, ProfileEntity>> getProfileInfo();
  Future<Either<Failure, String>> uploadProfileImage(File imagePath);
}
