import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hatley/core/error/failure.dart';
import 'package:hatley/data/datasources/addOrder_datasource/add_order_remote_datasource.dart';
import 'package:hatley/data/datasources/deleteOrder_datasource/delete_order_remote_datasource.dart';
import 'package:hatley/data/datasources/getAllOrders_datasource/getAll_orders_remote_datasource.dart';
import 'package:hatley/domain/entities/order_entity.dart';
import 'package:hatley/domain/repo/order_repo.dart';

class OrderRepoImpl implements OrderRepo {
  AddOrderRemoteDatasource addOrderRemoteDatasource;
  GetAllOrdersRemoteDataSource getAllOrdersRemoteDataSource;
  DeleteOrderRemoteDataSource deleteOrderRemoteDataSource;
  OrderRepoImpl(
    this.addOrderRemoteDatasource,
    this.getAllOrdersRemoteDataSource,
    this.deleteOrderRemoteDataSource,
  );
  @override
  Future<Either<Failure, void>> addOrder({
    required String description,
    required String orderGovernorateFrom,
    required String orderZoneFrom,
    required String orderCityFrom,
    required String detailesAddressFrom,
    required String orderGovernorateTo,
    required String orderZoneTo,
    required String orderCityTo,
    required String detailesAddressTo,
    required DateTime orderTime,
    required num price,
  }) async {
    try {
      await addOrderRemoteDatasource.addOrder(
        description: description,
        orderGovernorateFrom: orderGovernorateFrom,
        orderZoneFrom: orderZoneFrom,
        orderCityFrom: orderCityFrom,
        detailesAddressFrom: detailesAddressFrom,
        orderGovernorateTo: orderGovernorateTo,
        orderZoneTo: orderZoneTo,
        orderCityTo: orderCityTo,
        detailesAddressTo: detailesAddressTo,
        orderTime: orderTime,
        price: price,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllOrders() async {
    try {
      final result = await getAllOrdersRemoteDataSource.getAllOrders();
      final entityList = result.map((e) => e.toEntity()).toList();
      return Right(entityList);
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrder(int orderId) async {
    try {
      await deleteOrderRemoteDataSource.deleteOrder(orderId);
      return Future.value(Right(null));
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
