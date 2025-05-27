import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/auth_entity.dart';
import 'package:hatley/domain/repo/user_repo.dart';
import '../../core/local/token_storage.dart';

class SignInUseCase {
  final UserRepo loginRepo;
  final TokenStorage tokenStorage;

  SignInUseCase(this.loginRepo, this.tokenStorage);

  Future<Either<Failure, AuthEntity>> call({
    required String email,
    required String password,
  }) async {
    final result = await loginRepo.loginUser(email: email, password: password);

    result.fold(
          (_) {},
          (authEntity) async {
        await tokenStorage.saveToken(authEntity.token, authEntity.expiration);
      },
    );

    return result;
  }
}
