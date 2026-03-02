import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/core/api/api_client.dart';
import 'package:dairymart/core/api/api_endpoints.dart';
import 'package:dairymart/features/orders/data/models/order_model.dart';

final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>((ref) {
  return OrderRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
  );
});

class OrderRemoteDataSource {
  final ApiClient _apiClient;

  OrderRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.orders}/my-orders');
      if (response.statusCode == 200 && response.data['success']) {
        final list = response.data['data'] as List;
        return list.map((i) => OrderModel.fromJson(i)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.orders,
        data: orderData,
      );
      if (response.statusCode == 201 && response.data['success']) {
        return OrderModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  // Admin Methods
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.orders}/admin/all');
      if (response.statusCode == 200 && response.data['success']) {
        final list = response.data['data'] as List;
        return list.map((i) => OrderModel.fromJson(i)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.orders}/admin/$orderId/status',
        data: {'status': status},
      );
      if (response.statusCode != 200) {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}



