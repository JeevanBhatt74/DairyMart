import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/products/domain/repositories/product_repository.dart';

class CreateProductParams {
  final Map<String, dynamic> productData;
  final File imageFile;

  CreateProductParams({required this.productData, required this.imageFile});
}

class CreateProductUseCase extends UseCase<void, CreateProductParams> {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateProductParams params) async {
    return await repository.createProduct(params.productData, params.imageFile);
  }
}


