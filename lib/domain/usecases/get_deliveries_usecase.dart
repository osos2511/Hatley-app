import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/deliveries_entity.dart';
import 'package:hatley/domain/repo/deliveries_repo.dart';

class GetDeliveriesUsecase {
  final DeliveriesRepo deliveriesRepo;

  GetDeliveriesUsecase(this.deliveriesRepo);

  Future<Either<Failure, List<DeliveriesEntity>>> call() {
    return deliveriesRepo.getAllDeliveries();
  }
}
