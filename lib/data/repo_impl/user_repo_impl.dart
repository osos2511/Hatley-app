import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/data/datasources/logout_datasource/logout_remote_datasource.dart';
import 'package:hatley/data/datasources/register_datasource/register_remote_datasource.dart';
import 'package:hatley/data/datasources/signIn_datasource/signIn_remote_datasource.dart';
import 'package:hatley/domain/entities/auth_entity.dart';
import '../../domain/repo/user_repo.dart';

class UserRepoImpl implements UserRepo{
  final RegisterRemoteDataSource registerRemoteDataSource;
  final SignInRemoteDataSource signInRemoteDataSource;
  final LogOutRemoteDatasource logOutRemoteDatasource;

  UserRepoImpl(this.registerRemoteDataSource,this.signInRemoteDataSource,this.logOutRemoteDatasource);

  @override
  Future<Either<Failure,String>> registerUser({
    required String userName,
    required String phone,
    required String email,
    required String password
  }) async{
    try{
      final result=await registerRemoteDataSource.registerUser(userName: userName, phone: phone, email: email, password: password);
      return Right(result);
    }
    catch(e){
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> loginUser({required String email, required String password}) async{
    try{
      final result=await signInRemoteDataSource.signInUser(email: email, password: password);
      return Right(result.toEntity());
    }catch(e){
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> logOutUser() async{
    try{
      final result=await logOutRemoteDatasource.logOut();
      return Right(result);
    }catch(e){
      return Left(ServerFailure(e.toString()));
    }
  }


}