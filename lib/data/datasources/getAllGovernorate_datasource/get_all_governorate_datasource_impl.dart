import 'package:dio/dio.dart';
import 'package:hatley/data/datasources/getAllGovernorate_datasource/get_all_governorate_remote_datasource.dart';
import 'package:hatley/data/model/governorate_response.dart';

class GetAllGovernorateDataSourceImpl implements GetAllGovernorateRemoteDataSource{
  final Dio dio;
  GetAllGovernorateDataSourceImpl({required this.dio});
  @override
  Future<List<GovernorateResponse>> getAllGovernorate() async{
    try{
      final response= await dio.get('Governorate');
      if(response.statusCode==200||response.statusCode==201){
        return response.data.map((e)=>GovernorateResponse.fromJson(e)).toList();
      }else{
        throw Exception('get Governorate is failed: ${response.statusCode}');
      }
    }on DioException catch(e){
      throw Exception('Network error: ${e.message}');
    }
  }

}