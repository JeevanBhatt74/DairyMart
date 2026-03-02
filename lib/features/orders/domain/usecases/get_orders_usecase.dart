import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/orders/domain/entities/order_entity.dart';
import 'package:dairymart/features/orders/domain/repositories/order_repository.dart';

class GetOrdersUseCase extends UseCase<List<OrderEntity>, NoParams> {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) async {
    return await repository.getOrders();
  }
}


