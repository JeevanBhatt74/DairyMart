import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/features/orders/domain/entities/order_entity.dart';
import 'package:dairymart/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:dairymart/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:dairymart/features/orders/domain/usecases/get_all_orders_usecase.dart';
import 'package:dairymart/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:dairymart/features/orders/data/repositories/order_repository_impl.dart';
import 'package:dairymart/core/usecases/usecase.dart';

// ========== USE CASE PROVIDERS ==========
final getOrdersUseCaseProvider = Provider<GetOrdersUseCase>((ref) {
  return GetOrdersUseCase(ref.read(orderRepositoryProvider));
});

final createOrderUseCaseProvider = Provider<CreateOrderUseCase>((ref) {
  return CreateOrderUseCase(ref.read(orderRepositoryProvider));
});

final getAllOrdersUseCaseProvider = Provider<GetAllOrdersUseCase>((ref) {
  return GetAllOrdersUseCase(ref.read(orderRepositoryProvider));
});

final updateOrderStatusUseCaseProvider = Provider<UpdateOrderStatusUseCase>((ref) {
  return UpdateOrderStatusUseCase(ref.read(orderRepositoryProvider));
});

// ========== STATE WRAPPER ==========
class OrdersState {
  final bool isLoading;
  final List<OrderEntity> orders;
  final String? error;
  final bool isOrderCreated;
  final OrderEntity? lastCreatedOrder;

  OrdersState({
    this.isLoading = false,
    this.orders = const [],
    this.error,
    this.isOrderCreated = false,
    this.lastCreatedOrder,
  });

  OrdersState copyWith({
    bool? isLoading,
    List<OrderEntity>? orders,
    String? error,
    bool? isOrderCreated,
    OrderEntity? lastCreatedOrder,
  }) {
    return OrdersState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      error: error,
      isOrderCreated: isOrderCreated ?? this.isOrderCreated,
      lastCreatedOrder: lastCreatedOrder ?? this.lastCreatedOrder,
    );
  }
}

// ========== NOTIFIER ==========
class OrdersNotifier extends StateNotifier<OrdersState> {
  final GetOrdersUseCase _getOrdersUseCase;
  final CreateOrderUseCase _createOrderUseCase;
  final GetAllOrdersUseCase _getAllOrdersUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;

  OrdersNotifier({
    required GetOrdersUseCase getOrdersUseCase,
    required CreateOrderUseCase createOrderUseCase,
    required GetAllOrdersUseCase getAllOrdersUseCase,
    required UpdateOrderStatusUseCase updateOrderStatusUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase,
        _createOrderUseCase = createOrderUseCase,
        _getAllOrdersUseCase = getAllOrdersUseCase,
        _updateOrderStatusUseCase = updateOrderStatusUseCase,
        super(OrdersState()) {
    getOrders();
  }

  Future<void> getOrders() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getOrdersUseCase(NoParams());
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (orders) => state = state.copyWith(isLoading: false, orders: orders),
    );
  }

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    state = state.copyWith(isLoading: true, error: null, isOrderCreated: false, lastCreatedOrder: null);
    final result = await _createOrderUseCase(orderData);
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (order) {
        final currentOrders = [...state.orders];
        currentOrders.insert(0, order);
        state = state.copyWith(isLoading: false, isOrderCreated: true, orders: currentOrders, lastCreatedOrder: order);
      },
    );
  }
  
  void resetOrderCreated() {
    state = state.copyWith(isOrderCreated: false, lastCreatedOrder: null);
  }

  // Admin Methods
  Future<void> getAdminOrders() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getAllOrdersUseCase(NoParams());
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (orders) => state = state.copyWith(isLoading: false, orders: orders),
    );
  }

  Future<void> updateStatus(String id, String status) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _updateOrderStatusUseCase(UpdateOrderStatusParams(orderId: id, status: status));

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (_) {
        getAdminOrders(); // Refresh list
      },
    );
  }
}

// ========== PROVIDER ==========
final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  return OrdersNotifier(
    getOrdersUseCase: ref.read(getOrdersUseCaseProvider),
    createOrderUseCase: ref.read(createOrderUseCaseProvider),
    getAllOrdersUseCase: ref.read(getAllOrdersUseCaseProvider),
    updateOrderStatusUseCase: ref.read(updateOrderStatusUseCaseProvider),
  );
});


