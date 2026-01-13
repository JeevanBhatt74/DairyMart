import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import '../features/splash/presentation/pages/splash_page.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DairyMart',
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
    );
  }
}