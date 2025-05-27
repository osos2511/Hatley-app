import 'package:dio/dio.dart';

class DioFactory{
  static Dio createDio(){
    final BaseOptions options=BaseOptions(
      baseUrl: "https://hatley.runasp.net/api/",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );
    final dio=Dio(options);
    return dio;
  }
}