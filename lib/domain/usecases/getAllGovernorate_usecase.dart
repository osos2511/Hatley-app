import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/governorate_entity.dart';
import 'package:hatley/domain/repo/location_repo.dart';

class GetAllGovernorateUseCase{
  LocationRepo locationRepo;
  GetAllGovernorateUseCase(this.locationRepo);
  Future<Either<Failure,List<GovernorateEntity>>> call(){
    return locationRepo.getAllGovernorate();
  }
}