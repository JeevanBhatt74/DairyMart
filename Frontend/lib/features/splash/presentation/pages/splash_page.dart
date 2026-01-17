import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your pages and provider
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../../../../features/auth/presentation/pages/login_page.dart';
import '../../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../../features/onboarding/presentation/pages/onboarding_page.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final primaryBlue = const Color(0xFF29ABE2);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.elasticOut)),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.6, curve: Curves.easeIn)),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.6, curve: Curves.easeOut)),
    );

    _controller.forward();
    
    // Call our new check function instead of just navigating
    _checkStatus();
  }

  // --- NEW LOGIC HERE ---
  void _checkStatus() async {
    // 1. Wait for your animation to finish (3.5 seconds)
    await Future.delayed(const Duration(milliseconds: 3500));

    if (!mounted) return;

    // 2. Check if onboarding is completed
    final prefs = ref.read(sharedPreferencesProvider);
    final isOnboardingCompleted = prefs.getBool('is_onboarding_completed') ?? false;

    // 3. If onboarding NOT completed, show onboarding screens
    if (!isOnboardingCompleted) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const OnboardingPage())
      );
      return;
    }

    // 4. Onboarding is done, check if user is logged in
    final sessionService = UserSessionService();
    final token = await sessionService.getToken();
    print('🔍 DEBUG: Token from storage = $token'); // Debug log
    final isLoggedIn = token != null && token.isNotEmpty;

    // 5. If logged in, go to Dashboard; otherwise go to LoginPage
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const DashboardPage())
      );
    } else {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const LoginPage())
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.storefront, size: 80, color: primaryBlue),
                ),
              ),
            ),
            const SizedBox(height: 40),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    Text(
                      "DairyMart",
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                    Text(
                      "Freshness Delivered Daily",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
            
            FadeTransition(
              opacity: _fadeAnimation,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}