import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/core/api/api_client.dart';
import 'package:dairymart/core/api/api_endpoints.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSource(ref.read(apiClientProvider));
});

class ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSource(this._apiClient);

  /// Upload profile image to backend
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      print('ðŸ“¤ Starting upload to backend');
      final response = await _apiClient.uploadFile(
        ApiEndpoints.uploadProfileImage,
        file: imageFile,
        fieldName: 'profilePicture',
      );

      print('ðŸ“¥ Response received: ${response.statusCode}');
      print('ðŸ“¥ Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Backend returns different response formats - try each
        print('ðŸ“¥ Full Response data: ${response.data}');
        
        final imageUrl = response.data['imageUrl'] ?? 
                        response.data['data']?['profilePicture'] ?? 
                        response.data['data']?['imageUrl'] ??
                        response.data['profilePicture'] ?? 
                        response.data['url'] ??
                        '';
        
        print('ðŸ” Parsed image URL: $imageUrl');
        print('ðŸ” Image URL is empty: ${imageUrl.isEmpty}');
        print('ðŸ” Image URL type: ${imageUrl.runtimeType}');
        
        if (imageUrl.isEmpty) {
          print('âš ï¸ No image URL found in response!');
          // Try to construct it manually from filename
          if (response.data['data'] is Map && response.data['data']['user'] is Map) {
            final user = response.data['data']['user'];
            if (user['profilePicture'] != null) {
              print('âœ… Found profilePicture in user data: ${user['profilePicture']}');
            }
          }
          throw Exception('No image URL returned from server. Response: ${response.data}');
        }
        return imageUrl;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to upload image. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('âŒ DioException during upload: ${e.message}');
      print('âŒ Response data: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Upload failed');
    } catch (e) {
      print('âŒ Exception during upload: $e');
      throw Exception('Upload failed: $e');
    }
  }

  /// Update user profile information
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.updateProfile,
        data: profileData,
      );

      if (response.statusCode == 200) {
        return response.data['data'] ?? response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update profile');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Update failed');
    }
  }

  /// Get user profile information
  Future<Map<String, dynamic>> getProfile() async {
    try {
      print('ðŸ“¥ fetching user profile...');
      final response = await _apiClient.get(ApiEndpoints.profile);

      if (response.statusCode == 200) {
        print('âœ… Profile fetched successfully: ${response.data}');
        return response.data['data'] ?? response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch profile');
      }
    } on DioException catch (e) {
      print('âŒ Error fetching profile: ${e.message}');
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Fetch failed');
    }
  }
}


