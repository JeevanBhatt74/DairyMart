import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetectorService {
  final Function onShake;
  final double shakeThreshold;
  final Duration debounceDuration;

  StreamSubscription? _subscription;
  DateTime? _lastShakeTime;

  ShakeDetectorService({
    required this.onShake,
    this.shakeThreshold = 12.0, // m/s^2
    this.debounceDuration = const Duration(seconds: 2),
  });

  void start() {
    print("🚀 Shake Detector Started");
    _subscription = userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      // Calculate total acceleration (excluding gravity)
      double acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (acceleration > 5.0) { // Log even small movements for debugging
        print("📱 Shake Acceleration: ${acceleration.toStringAsFixed(2)}");
      }

      if (acceleration > shakeThreshold) {
        DateTime now = DateTime.now();
        if (_lastShakeTime == null || 
            now.difference(_lastShakeTime!) > debounceDuration) {
          _lastShakeTime = now;
          print("✅ SHAKE DETECTED! Triggering onShake callback.");
          onShake();
        }
      }
    });
  }

  void stop() {
    print("🛑 Shake Detector Stopped");
    _subscription?.cancel();
  }
}
