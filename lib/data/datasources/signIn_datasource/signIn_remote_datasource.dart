import 'package:hatley/data/model/sign_in_response.dart';

abstract class SignInRemoteDataSource {
  Future<SignInResponse> signInUser({
    required String email,
    required String password,
  });
}
