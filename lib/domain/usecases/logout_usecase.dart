import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/repo/user_repo.dart';

class LogOutUseCase{
  UserRepo userRepo;
  LogOutUseCase(this.userRepo);
  Future<Either<Failure,String>> call(){
    return userRepo.logOutUser();
  }
}