import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Import the parent Onboarding controller
import 'package:dairymart/screens/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // --- Theme Colors ---
  final primaryBlue = const Color(0xFF29ABE2);
  final backgroundGray = const Color.fromARGB(255, 255, 255, 255); 
  final circleColor = Colors.white; 

  @override
  void initState() {
    super.initState();

    // 1. Setup Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // 2. Define Animations
    
    // Logo bounce
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // Text fade in
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
      ),
    );

    // Text slide up
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    // Wait for animation + delay
    await Future.delayed(const Duration(milliseconds: 3500));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          // Navigate to the Parent Onboarding Screen (PageView)
          builder: (context) => const OnboardingScreen(),
        ),
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
      backgroundColor: backgroundGray, // Matches your Logo background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- Animated Logo Section ---
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                // Explicit larger size for the circle (240x240)
                width: 240,
                height: 240,
                padding: const EdgeInsets.all(10), // Minimal padding to maximize logo size
                decoration: BoxDecoration(
                  color: circleColor, 
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      // FIXED: used .withValues(alpha: ...)
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain, // Ensures logo fills the space without cropping
                  errorBuilder: (context, error, stackTrace) => 
                    Icon(Icons.storefront_rounded, size: 100, color: primaryBlue),
                ),
              ),
            ),
            
            const SizedBox(height: 50),

            // --- Animated Text Section ---
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
                        color: primaryBlue, // Blue Text
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Freshness Delivered Daily",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600], 
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 80),

            // --- Loading Indicator ---
            FadeTransition(
              opacity: _fadeAnimation,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryBlue), // Blue Loader
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Splash screen animation logic completed.