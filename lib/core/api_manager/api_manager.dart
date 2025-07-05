import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart'; // ✅ استيراد Dartz
import 'package:hatley/data/model/traking_response.dart';
import '../error/failure.dart'; // ✅ استيراد فئات الفشل

class TrakingApiManager {
  final Dio dio;

  TrakingApiManager({required Dio dio}) : dio = dio;

  // ✅ تغيير نوع الإرجاع ليصبح Future<Either<Failure, List<TrakingResponse>>>
  Future<Either<Failure, List<TrakingResponse>>> getAllTrackingData() async {
    try {
      final response = await dio.get('Traking');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        final List<TrakingResponse> trackingList =
            data
                .map((e) => TrakingResponse.fromJson(e as Map<String, dynamic>))
                .toList();
        return Right(trackingList); // ✅ في حالة النجاح، نرجع Right
      } else if (response.statusCode == 400 &&
          response.data == "No Records exist") {
        // إذا كان هناك 400 مع رسالة محددة، عاملها كنجاح بقائمة فارغة أو فشل مخصص
        return Right(
          [],
        ); // أو Left(ServerFailure("No records exist for tracking.")); حسب ما تفضل أن تعتبره فشل أو نجاح
      } else {
        // ✅ في حالة فشل الخادم، نرجع Left(ServerFailure)
        return Left(
          ServerFailure(
            'Failed to load tracking data: ${response.statusCode} ${response.data}',
          ),
        );
      }
    } on DioException catch (e) {
      // ✅ التعامل مع أخطاء الشبكة أو الـ Dio
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.unknown) {
        return Left(NetworkFailure("Please check your internet connection."));
      } else if (e.response != null) {
        // أخطاء الخادم التي تأتي مع استجابة (مثل 404, 500)
        return Left(
          ServerFailure(
            "Server error: ${e.response?.statusCode} - ${e.response?.data['message'] ?? 'Unknown error'}",
          ),
        );
      }
      return Left(
        ServerFailure('An unexpected Dio error occurred: ${e.message}'),
      );
    } catch (e) {
      // ✅ لأي أخطاء أخرى غير متوقعة
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }
}
