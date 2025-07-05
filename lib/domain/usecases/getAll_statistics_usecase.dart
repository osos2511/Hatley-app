import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/statistics_entity.dart';
import 'package:hatley/domain/repo/profile_repo.dart';

class GetallStatisticsUsecase {
  final ProfileRepo statisticsRepo;

  GetallStatisticsUsecase(this.statisticsRepo);

  Future<Either<Failure, StatisticsEntity>> call() async {
    return await statisticsRepo.getAllStatistics();
  }
}
