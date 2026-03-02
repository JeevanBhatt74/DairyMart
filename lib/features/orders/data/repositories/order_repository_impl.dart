import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/orders/domain/entities/order_entity.dart';
import 'package:dairymart/features/orders/domain/repositories/order_repository.dart';
import 'package:dairymart/features/orders/data/datasources/remote/order_remote_data_source.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(
    dataSource: ref.read(orderRemoteDataSourceProvider),
  );
});

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _dataSource;

  OrderRepositoryImpl({required OrderRemoteDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      final orders = await _dataSource.getOrders();
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder(Map<String, dynamic> orderData) async {
    try {
      final order = await _dataSource.createOrder(orderData);
      return Right(order);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllOrders() async {
    try {
      final orders = await _dataSource.getAllOrders();
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(String orderId, String status) async {
    try {
      await _dataSource.updateOrderStatus(orderId, status);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}




