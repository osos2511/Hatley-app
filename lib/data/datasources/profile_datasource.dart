import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hatley/data/model/profile_response.dart';
import 'package:hatley/data/model/statistics_response.dart';

abstract class ProfileDatasource {
  Future<ProfileResponse> getProfileInfo();
  Future<String> uploadProfileImage(File imagePath);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> updateProfileInfo(String name, String email, String phone);
  Future<StatisticsResponse> getAllStatistics();
}

class ProfileDataSourceImpl implements ProfileDatasource {
  final Dio dio;
  ProfileDataSourceImpl({required this.dio});
  @override
  Future<ProfileResponse> getProfileInfo() async {
    try {
      final response = await dio.get('User/profile');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProfileResponse.fromJson(response.data);
      } else {
        throw Exception('Get profile info failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<String> uploadProfileImage(File imagePath) async {
    try {
      final formData = FormData.fromMap({
        'profile_img': await MultipartFile.fromFile(
          imagePath.path,
          filename: imagePath.path.split('/').last,
        ),
      });
      final response = await dio.post('User/uploadImage', data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data.toString();
      } else {
        throw Exception('Upload profile image failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final response = await dio.post(
        'User/changepassword',
        data: {'old_password': oldPassword, 'new_password': newPassword},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Change password failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> updateProfileInfo(
    String name,
    String email,
    String phone,
  ) async {
    try {
      final response = await dio.put(
        'User',
        data: {'name': name, 'email': email, 'phone': phone},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Update profile info failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<StatisticsResponse> getAllStatistics() async {
    try {
      final response = await dio.get('Order/Statistics');
      if (response.statusCode == 200) {
        return StatisticsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load statistics');
      }
    } catch (e) {
      throw Exception('Failed to load statistics: $e');
    }
  }
}
