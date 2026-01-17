import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

class ConnectivityService {
  final _connectivity = Connectivity();

  /// Check if device has internet connection
  Future<bool> hasInternetConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.contains(ConnectivityResult.mobile) || 
             result.contains(ConnectivityResult.wifi) ||
             result.contains(ConnectivityResult.ethernet);
    } catch (e) {
      return false;
    }
  }

  /// Get current connectivity status
  Future<ConnectivityResult> getConnectivityStatus() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.isNotEmpty ? result.first : ConnectivityResult.none;
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  /// Stream connectivity changes
  Stream<ConnectivityResult> onConnectivityChanged() {
    return _connectivity.onConnectivityChanged.map((result) {
      return result.isNotEmpty ? result.first : ConnectivityResult.none;
    });
  }
}
