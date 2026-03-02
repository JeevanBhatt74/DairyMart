import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/app/theme/app_theme.dart';
import 'package:dairymart/app/theme/theme_provider.dart';
import 'package:dairymart/features/splash/presentation/pages/splash_page.dart';
import 'package:dairymart/core/providers/shake_detector_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final navigatorKey = ref.watch(navigatorKeyProvider);
    
    // Initialize the shake detector service
    ref.watch(shakeDetectorProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'DairyMart',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashPage(),
    );
  }
}
