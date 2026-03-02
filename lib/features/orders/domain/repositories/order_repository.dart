import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/orders/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders();
  Future<Either<Failure, OrderEntity>> createOrder(Map<String, dynamic> orderData);
  Future<Either<Failure, List<OrderEntity>>> getAllOrders();
  Future<Either<Failure, void>> updateOrderStatus(String orderId, String status);
}


