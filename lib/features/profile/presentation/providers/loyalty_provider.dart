import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dairymart/core/api/api_endpoints.dart';

class LoyaltyData {
  final int loyaltyPoints;
  final int qualifyingOrderCount;
  final bool discountAvailable;
  final int pointsToNextDiscount;
  final int ordersToNextBonus;

  LoyaltyData({
    required this.loyaltyPoints,
    required this.qualifyingOrderCount,
    required this.discountAvailable,
    required this.pointsToNextDiscount,
    required this.ordersToNextBonus,
  });

  factory LoyaltyData.empty() => LoyaltyData(
    loyaltyPoints: 0,
    qualifyingOrderCount: 0,
    discountAvailable: false,
    pointsToNextDiscount: 100,
    ordersToNextBonus: 5,
  );

  factory LoyaltyData.fromJson(Map<String, dynamic> json) => LoyaltyData(
    loyaltyPoints: json['loyaltyPoints'] ?? 0,
    qualifyingOrderCount: json['qualifyingOrderCount'] ?? 0,
    discountAvailable: json['discountAvailable'] ?? false,
    pointsToNextDiscount: json['pointsToNextDiscount'] ?? 100,
    ordersToNextBonus: json['ordersToNextBonus'] ?? 5,
  );
}

final loyaltyProvider = FutureProvider<LoyaltyData>((ref) async {
  try {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) return LoyaltyData.empty();

    final dio = Dio();
    final res = await dio.get(
      ApiEndpoints.loyaltyPoints,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode == 200 && res.data['success'] == true) {
      return LoyaltyData.fromJson(res.data['data']);
    }
  } catch (e) {
    // Silently fail â€” return empty
  }
  return LoyaltyData.empty();
});

