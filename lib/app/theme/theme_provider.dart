import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light/light.dart';

// Create a state provider for the lux value itself for debugging
final luxProvider = StateProvider<int>((ref) => -1);

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ref);
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final Ref _ref;
  ThemeNotifier(this._ref) : super(ThemeMode.system) {
    _initLightSensor();
  }

  Light? _light;
  StreamSubscription? _subscription;
  bool _isManualOverride = false;
  
  bool get isAutoMode => !_isManualOverride;
  
  static const int _luxThreshold = 30; 

  void _initLightSensor() {
    try {
      _light = Light();
      _subscription = _light?.lightSensorStream.listen(
        (luxValue) {
          _ref.read(luxProvider.notifier).state = luxValue;
          if (!_isManualOverride) {
            _onSensorData(luxValue);
          }
        }, 
        onError: (error) {
          if (!_isManualOverride) state = ThemeMode.system;
        },
        cancelOnError: false,
      );
    } catch (e) {
      if (!_isManualOverride) state = ThemeMode.system;
    }
  }

  void _onSensorData(int luxValue) {
    if (luxValue < _luxThreshold) {
      if (state != ThemeMode.dark) {
        state = ThemeMode.dark;
      }
    } else {
      if (state != ThemeMode.light) {
        state = ThemeMode.light;
      }
    }
  }

  void toggleTheme() {
    _isManualOverride = true;
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.dark;
    }
  }

  void setAutoMode(bool auto) {
    _isManualOverride = !auto;
    if (auto) {
      state = ThemeMode.system; // Reverts to system brightness
      // The sensor stream will pick up the current lux and optionally override again
    } else {
      // If we turn off auto, just lock it to the current theme
      // If the state is 'system', we need to resolve what it actually looks like.
      // Easiest is to default to light or dark when Auto is flipped off, 
      // but the toggle will handle the specific state.
      state = state == ThemeMode.system ? ThemeMode.light : state;
    }
  }

  void resetToSystem() {
    _isManualOverride = false;
    state = ThemeMode.system;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
