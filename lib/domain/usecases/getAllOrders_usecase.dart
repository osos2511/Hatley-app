import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/entities/order_entity.dart';
import 'package:hatley/domain/repo/order_repo.dart';

class GetallordersUseCase {
  OrderRepo orderRepo;
  GetallordersUseCase(this.orderRepo);
  Future<Either<Failure, List<OrderEntity>>> call() {
    return orderRepo.getAllOrders();
  }
}
