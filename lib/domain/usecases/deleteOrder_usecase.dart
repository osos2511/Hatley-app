import 'package:dartz/dartz.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/domain/repo/order_repo.dart';

class DeleteOrderUsecase {
  OrderRepo orderRepo;
  DeleteOrderUsecase(this.orderRepo);
  Future<Either<Failure, void>> call(int orderId) {
    return orderRepo.deleteOrder(orderId);
  }
}
