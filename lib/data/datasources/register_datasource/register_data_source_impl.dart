import 'package:dio/dio.dart';
import 'package:hatley/data/datasources/register_datasource/register_remote_datasource.dart';

class RegisterDataSourceImpl implements RegisterRemoteDataSource{
  final Dio dio;
  RegisterDataSourceImpl({required this.dio});

  @override
  Future<String> registerUser({
    required String userName,
    required String phone,
    required String email,
    required String password
  }) async{
    try{
      FormData formData=FormData.fromMap({
        'Name': userName,
        'phone': phone,
        'Email': email,
        'Password': password,
      });
      final response=await dio.post(
        'userAccount/register',
        data: formData
      );
      if(response.statusCode==200||response.statusCode==201){
        return response.data.toString();
      }else{
        throw Exception('Register failed: ${response.statusCode}');
      }
    }on DioException catch(e){
      throw Exception('Network error: ${e.message}');
    }
  }
}