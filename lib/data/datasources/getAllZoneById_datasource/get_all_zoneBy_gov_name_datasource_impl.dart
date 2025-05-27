import 'package:dio/dio.dart';
import 'package:hatley/data/datasources/getAllZoneById_datasource/get_all_zoneBy_gov_name_remote_datasource.dart';
import 'package:hatley/data/model/zone_response.dart';

class GetAllZoneByGovNameDatasourceImpl implements GetAllZoneByGovNameRemoteDataSource{
  final Dio dio;
  GetAllZoneByGovNameDatasourceImpl({required this.dio});

  @override
  Future<List<ZoneResponse>> getAllZoneByGovName({required String govName}) async{
    try{
      final response= await dio.get(
          'Zone',
          queryParameters: {'governorate_name': govName});
      if(response.statusCode==200||response.statusCode==201){
        final data = response.data as List;
        return data.map((e)=>ZoneResponse.fromJson(e)).toList();
      }else{
        throw Exception('get Zone is failed: ${response.statusCode}');
      }
    }on DioException catch(e){
      throw Exception('Network error: ${e.message}');
    }
  }

}