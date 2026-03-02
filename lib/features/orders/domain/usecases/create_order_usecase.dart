import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/orders/domain/entities/order_entity.dart';
import 'package:dairymart/features/orders/domain/repositories/order_repository.dart';

class CreateOrderUseCase extends UseCase<OrderEntity, Map<String, dynamic>> {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(Map<String, dynamic> orderData) async {
    return await repository.createOrder(orderData);
  }
}


