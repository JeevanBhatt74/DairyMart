import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/core/services/shake_detector_service.dart';
import 'package:dairymart/core/common/widgets/bug_report_dialog.dart';
import 'package:flutter/material.dart';

// Key to access Navigator without context
final navigatorKeyProvider = Provider((ref) => GlobalKey<NavigatorState>());

final shakeDetectorProvider = Provider<ShakeDetectorService>((ref) {
  final navKey = ref.watch(navigatorKeyProvider);
  
  final service = ShakeDetectorService(
    onShake: () {
      final context = navKey.currentState?.overlay?.context;
      if (context != null) {
        BugReportDialog.show(context);
      }
    },
  );

  // Automatically start and stop with provider lifecycle
  service.start();
  ref.onDispose(() => service.stop());
  
  return service;
});

