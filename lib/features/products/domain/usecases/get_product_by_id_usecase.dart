import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/products/domain/entities/product_entity.dart';
import 'package:dairymart/features/products/domain/repositories/product_repository.dart';

class GetProductByIdUseCase extends UseCase<ProductEntity, String> {
  final ProductRepository repository;

  GetProductByIdUseCase(this.repository);

  @override
  Future<Either<Failure, ProductEntity>> call(String id) async {
    return await repository.getProductById(id);
  }
}


