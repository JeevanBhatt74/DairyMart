import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/core/api/api_client.dart';
import 'package:dairymart/core/api/api_endpoints.dart';
import 'package:dairymart/features/cart/data/models/cart_model.dart';

final cartRemoteDataSourceProvider = Provider<CartRemoteDataSource>((ref) {
  return CartRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
  );
});

class CartRemoteDataSource {
  final ApiClient _apiClient;

  CartRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<CartModel> getCart() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.cart);
      if (response.statusCode == 200 && response.data['success']) {
        return CartModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<CartModel> addToCart(String productId, int quantity) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.cart,
        data: {'productId': productId, 'quantity': quantity},
      );
      if (response.statusCode == 200 && response.data['success']) {
        return CartModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<CartModel> removeFromCart(String productId) async {
    try {
      final response = await _apiClient.delete('${ApiEndpoints.cart}/$productId');
      if (response.statusCode == 200 && response.data['success']) {
        return CartModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<CartModel> clearCart() async {
    try {
      final response = await _apiClient.delete(ApiEndpoints.cart);
      if (response.statusCode == 200 && response.data['success']) {
        return CartModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}



