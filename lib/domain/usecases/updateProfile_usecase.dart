import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/repo/profile_repo.dart';

class UpdateprofileUsecase {
  final ProfileRepo profileRepo;

  UpdateprofileUsecase(this.profileRepo);

  Future<Either<Failure, void>> call(
    String name,
    String email,
    String phone,
  ) async {
    return await profileRepo.updateProfileInfo(name, email, phone);
  }
}
