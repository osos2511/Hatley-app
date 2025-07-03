import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/repo/profile_repo.dart';

class UploadProfileImgUsecase {
  final ProfileRepo profileRepo;

  UploadProfileImgUsecase(this.profileRepo);

  Future<Either<Failure, String>> call(File imagePath) async {
    return await profileRepo.uploadProfileImage(imagePath);
  }
}
