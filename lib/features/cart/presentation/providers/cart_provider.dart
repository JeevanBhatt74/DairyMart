import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/features/cart/domain/entities/cart_entity.dart';
import 'package:dairymart/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:dairymart/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:dairymart/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:dairymart/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:dairymart/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:dairymart/core/usecases/usecase.dart';

// ========== USE CASE PROVIDERS ==========
final getCartUseCaseProvider = Provider<GetCartUseCase>((ref) {
  return GetCartUseCase(ref.read(cartRepositoryProvider));
});

final addToCartUseCaseProvider = Provider<AddToCartUseCase>((ref) {
  return AddToCartUseCase(ref.read(cartRepositoryProvider));
});

final removeFromCartUseCaseProvider = Provider<RemoveFromCartUseCase>((ref) {
  return RemoveFromCartUseCase(ref.read(cartRepositoryProvider));
});

final clearCartUseCaseProvider = Provider<ClearCartUseCase>((ref) {
  return ClearCartUseCase(ref.read(cartRepositoryProvider));
});

// ========== STATE WRAPPER ==========
class CartState {
  final bool isLoading;
  final CartEntity? cart;
  final String? error;

  CartState({this.isLoading = false, this.cart, this.error});

  CartState copyWith({bool? isLoading, CartEntity? cart, String? error}) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      cart: cart ?? this.cart,
      error: error,
    );
  }
}

// ========== NOTIFIER ==========
class CartNotifier extends StateNotifier<CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final RemoveFromCartUseCase _removeFromCartUseCase;
  final ClearCartUseCase _clearCartUseCase;

  CartNotifier({
    required GetCartUseCase getCartUseCase,
    required AddToCartUseCase addToCartUseCase,
    required RemoveFromCartUseCase removeFromCartUseCase,
    required ClearCartUseCase clearCartUseCase,
  })  : _getCartUseCase = getCartUseCase,
        _addToCartUseCase = addToCartUseCase,
        _removeFromCartUseCase = removeFromCartUseCase,
        _clearCartUseCase = clearCartUseCase,
        super(CartState()) {
    getCart();
  }

  Future<void> getCart() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getCartUseCase(NoParams());
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (cart) => state = state.copyWith(isLoading: false, cart: cart),
    );
  }

  Future<void> addToCart(String productId, int quantity) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _addToCartUseCase(AddToCartParams(productId: productId, quantity: quantity));
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (cart) => state = state.copyWith(isLoading: false, cart: cart),
    );
  }

  Future<void> removeFromCart(String productId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _removeFromCartUseCase(productId);
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (cart) => state = state.copyWith(isLoading: false, cart: cart),
    );
  }

  Future<void> clearCart() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _clearCartUseCase(NoParams());
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (cart) => state = state.copyWith(isLoading: false, cart: cart),
    );
  }
}

// ========== PROVIDER ==========
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(
    getCartUseCase: ref.read(getCartUseCaseProvider),
    addToCartUseCase: ref.read(addToCartUseCaseProvider),
    removeFromCartUseCase: ref.read(removeFromCartUseCaseProvider),
    clearCartUseCase: ref.read(clearCartUseCaseProvider),
  );
});


