import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/profile_entity.dart';
import 'package:hatley/domain/repo/profile_repo.dart';

class GetProfileInfoUsecase {
  ProfileRepo profileRepo;
  GetProfileInfoUsecase(this.profileRepo);
  Future<Either<Failure, ProfileEntity>> call() {
    return profileRepo.getProfileInfo();
  }
}
