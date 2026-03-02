import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/orders/domain/repositories/order_repository.dart';

class UpdateOrderStatusParams {
  final String orderId;
  final String status;

  UpdateOrderStatusParams({required this.orderId, required this.status});
}

class UpdateOrderStatusUseCase extends UseCase<void, UpdateOrderStatusParams> {
  final OrderRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateOrderStatusParams params) async {
    return await repository.updateOrderStatus(params.orderId, params.status);
  }
}


