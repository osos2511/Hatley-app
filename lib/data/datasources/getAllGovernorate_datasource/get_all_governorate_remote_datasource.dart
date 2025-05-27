import 'package:hatley/data/model/governorate_response.dart';

abstract class GetAllGovernorateRemoteDataSource{
  Future<List<GovernorateResponse>> getAllGovernorate();
}