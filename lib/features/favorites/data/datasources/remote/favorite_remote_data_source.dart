import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/core/api/api_client.dart';
import 'package:dairymart/core/api/api_endpoints.dart';
import 'package:dairymart/features/favorites/data/models/favorite_model.dart'; // Ensure correct import path

final favoriteRemoteDataSourceProvider = Provider<FavoriteRemoteDataSource>((ref) {
  return FavoriteRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
  );
});

class FavoriteRemoteDataSource {
  final ApiClient _apiClient;

  FavoriteRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<FavoriteModel>> getFavorites() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.favorites);
      if (response.statusCode == 200 && response.data['success']) {
        final list = response.data['data'] as List;
        return list
            .map((i) => FavoriteModel.fromJson(i))
            .where((fav) => fav.productId.isNotEmpty)
            .toList();
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<bool> toggleFavorite(String productId) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.favorites}/toggle',
        data: {'productId': productId},
      );
      if (response.statusCode == 200 && response.data['success']) {
        return response.data['isFavorited'];
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
  
  Future<bool> checkFavorite(String productId) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.favorites}/$productId');
      if (response.statusCode == 200 && response.data['success']) {
        return response.data['isFavorited'];
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}



