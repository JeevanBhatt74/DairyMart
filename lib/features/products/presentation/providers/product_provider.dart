import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/features/products/domain/entities/product_entity.dart';
import 'package:dairymart/features/products/domain/usecases/get_products_usecase.dart';
import 'package:dairymart/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:dairymart/features/products/domain/usecases/create_product_usecase.dart';
import 'package:dairymart/features/products/data/repositories/product_repository_impl.dart';
import 'package:dairymart/core/usecases/usecase.dart';

// ========== USE CASE PROVIDERS ==========
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.read(productRepositoryProvider));
});

final getProductByIdUseCaseProvider = Provider<GetProductByIdUseCase>((ref) {
  return GetProductByIdUseCase(ref.read(productRepositoryProvider));
});

final createProductUseCaseProvider = Provider<CreateProductUseCase>((ref) {
  return CreateProductUseCase(ref.read(productRepositoryProvider));
});

// ========== STATE WRAPPER ==========
class ProductState {
  final bool isLoading;
  final List<ProductEntity> products;
  final String? error;

  ProductState({this.isLoading = false, this.products = const [], this.error});

  ProductState copyWith({bool? isLoading, List<ProductEntity>? products, String? error}) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: error,
    );
  }
}

// ========== NOTIFIER ==========
class ProductNotifier extends StateNotifier<ProductState> {
  final GetProductsUseCase _getProductsUseCase;
  final CreateProductUseCase _createProductUseCase;

  ProductNotifier({
    required GetProductsUseCase getProductsUseCase,
    required CreateProductUseCase createProductUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _createProductUseCase = createProductUseCase,
        super(ProductState()) {
    getProducts();
  }

  Future<void> getProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getProductsUseCase(NoParams());
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (products) => state = state.copyWith(isLoading: false, products: products),
    );
  }

  Future<void> createProduct(Map<String, dynamic> data, File image) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _createProductUseCase(CreateProductParams(productData: data, imageFile: image));

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (_) {
        getProducts();
      },
    );
  }
}

// ========== PROVIDERS ==========
final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  return ProductNotifier(
    getProductsUseCase: ref.read(getProductsUseCaseProvider),
    createProductUseCase: ref.read(createProductUseCaseProvider),
  );
});

final productDetailProvider = FutureProvider.family<ProductEntity, String>((ref, id) async {
  final getProductByIdUseCase = ref.read(getProductByIdUseCaseProvider);
  final result = await getProductByIdUseCase(id);
  return result.fold(
    (failure) => throw failure.message,
    (product) => product,
  );
});



