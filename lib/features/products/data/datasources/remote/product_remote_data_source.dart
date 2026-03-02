import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/core/api/api_client.dart';
import 'package:dairymart/core/api/api_endpoints.dart';
import 'package:dairymart/features/products/data/models/product_model.dart';

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
  );
});

class ProductRemoteDataSource {
  final ApiClient _apiClient;

  ProductRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.products);
      if (response.statusCode == 200 && response.data['success']) {
        final list = response.data['data'] as List;
        return list.map((i) => ProductModel.fromJson(i)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.products}/$id');
      if (response.statusCode == 200 && response.data['success']) {
        return ProductModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<void> createProduct(Map<String, dynamic> productData, File imageFile) async {
    try {
      final response = await _apiClient.uploadFile(
        ApiEndpoints.products,
        file: imageFile,
        fieldName: 'image',
        additionalFields: productData,
      );
      
      if (response.statusCode != 201) {
        throw Exception(response.data['message'] ?? 'Failed to create product');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}



