abstract class RegisterRemoteDataSource{
  Future<String> registerUser({
    required String userName,
    required String phone,
    required String email,
    required String password
});
}