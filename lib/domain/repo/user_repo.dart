import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/auth_entity.dart';

abstract class UserRepo {
  Future<Either<Failure, String>> registerUser({
    required String userName,
    required String phone,
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthEntity>> loginUser({
    required String email,
    required String password
});

  Future<Either<Failure,String>> logOutUser();

}