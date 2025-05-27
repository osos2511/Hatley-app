import 'package:hatley/data/model/zone_response.dart';

abstract class GetAllZoneByGovNameRemoteDataSource{
  Future<List<ZoneResponse>> getAllZoneByGovName({required String govName});
}