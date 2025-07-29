import 'package:dio/dio.dart';
import 'package:hatley/core/local/token_storage.dart';
import 'package:hatley/core/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioFactory {
  static Future<Dio> createDio() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenStorage = TokenStorageImpl(prefs);

    final BaseOptions options = BaseOptions(
      baseUrl: "https://hatley.runasp.net/api/",
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    final dio = Dio(options);

    // ✅ إضافة التوكن إلى الهيدر عبر Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorage.getToken();
          AppLogger.debug(
            "Dio Interceptor - Token: ${token != null ? '***' : 'null'}",
          );

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          AppLogger.debug("Dio Request URL: ${options.uri}");
          AppLogger.debug("Dio Request Headers: ${options.headers}");
          AppLogger.debug("Dio Request Body: ${options.data}");
          return handler.next(options);
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    return dio;
  }
}
