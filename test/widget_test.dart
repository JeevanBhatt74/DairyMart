import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import your pages
import 'package:dairymart/features/splash/presentation/pages/splash_page.dart';
import 'package:dairymart/features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
  testWidgets('App starts, displays Splash, and navigates to Onboarding', (WidgetTester tester) async {
    
    // 1. Pump the SplashPage wrapped in ProviderScope AND MaterialApp.
    // MaterialApp is REQUIRED to fix the "No Directionality widget found" error.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SplashPage(),
        ),
      ),
    );

    // 2. Verify SplashPage is visible
    expect(find.byType(SplashPage), findsOneWidget, 
        reason: 'The application should start with the SplashPage visible.');

    // 3. Verify CircularProgressIndicator is present
    expect(find.byType(CircularProgressIndicator), findsOneWidget, 
        reason: 'The SplashPage should contain a loading indicator.');

    // 4. Wait for Animation + Timer (4 seconds total)
    // pumpAndSettle waits for all animations to complete
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // 5. Verify SplashPage is gone
    expect(find.byType(SplashPage), findsNothing, 
        reason: 'After timer, SplashPage should be gone.');
    
    // 6. Verify OnboardingPage is present
    expect(find.byType(OnboardingPage), findsOneWidget,
        reason: 'App should navigate to OnboardingPage.');
  });
}