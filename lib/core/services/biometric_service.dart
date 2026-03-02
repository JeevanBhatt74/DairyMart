import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> canAuthenticate() async {
    try {
      final bool canCheckBiometrics = await auth.canCheckBiometrics;
      final bool isDeviceSupported = await auth.isDeviceSupported();
      final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      print("🔍 Biometric Status:");
      print("   - canCheckBiometrics: $canCheckBiometrics");
      print("   - isDeviceSupported: $isDeviceSupported");
      print("   - availableBiometrics: $availableBiometrics");

      return canCheckBiometrics || isDeviceSupported;
    } catch (e) {
      print("❌ Biometric Check Error: $e");
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Verify your identity to authorize the delivery charge payment via eSewa/Khalti',
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      print("Biometric Error: ${e.code}");
      return false;
    } catch (e) {
      return false;
    }
  }
}
