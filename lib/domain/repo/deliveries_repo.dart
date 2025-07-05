import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/deliveries_entity.dart';

abstract class DeliveriesRepo {
  Future<Either<Failure, List<DeliveriesEntity>>> getAllDeliveries();
}
