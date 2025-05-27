import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/repo/user_repo.dart';

class LogOutUseCase{
  UserRepo logoutRepo;
  LogOutUseCase(this.logoutRepo);
  Future<Either<Failure,String>> call(){
    return logoutRepo.logOutUser();
  }
}