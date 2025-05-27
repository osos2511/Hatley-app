import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/repo/user_repo.dart';

class RegisterUseCase{
  final UserRepo userRepo;
  RegisterUseCase(this.userRepo);
  Future<Either<Failure,String>> call({
    required String userName,
    required String phone,
    required String email,
    required String password
}
){
 return userRepo.registerUser(userName: userName, phone: phone, email: email, password: password);
  }
}