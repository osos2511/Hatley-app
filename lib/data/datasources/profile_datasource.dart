import 'package:dio/dio.dart';
import 'package:hatley/data/model/profile_response.dart';

abstract class ProfileDatasource {
  Future<ProfileResponse> getProfileInfo();
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
}
