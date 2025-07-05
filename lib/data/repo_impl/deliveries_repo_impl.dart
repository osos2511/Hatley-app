import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/data/datasources/deliveries_datasource.dart';
import 'package:hatley/data/mappers/deliveries_mapper.dart';
import 'package:hatley/domain/entities/deliveries_entity.dart';
import 'package:hatley/domain/repo/deliveries_repo.dart';

class DeliveriesRepoImpl implements DeliveriesRepo {
  final DeliveriesDataSource deliveriesDataSource;

  DeliveriesRepoImpl(this.deliveriesDataSource);

  @override
  Future<Either<Failure, List<DeliveriesEntity>>> getAllDeliveries() async {
    try {
      final deliveries = await deliveriesDataSource.getAllDeliveries();
      return Right(deliveries.map((d) => d.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
