// Onboarding flow (parent screens)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../auth/login_screen.dart';

// Import the 3 separate screens
import 'onboarding1.dart';
import 'onboarding2.dart';
import 'onboarding3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;
  final primaryBlue = const Color(0xFF29ABE2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PageView loads the separate files
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 2);
            },
            children: const [
              Onboarding1(),
              Onboarding2(),
              Onboarding3(),
            ],
          ),
          
          // Bottom Navigation Area
          Container(
            alignment: const Alignment(0, 0.85),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip Button
                TextButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                  child: Text("Skip", style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w600)),
                ),

                // Dots Indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    spacing: 16,
                    dotColor: const Color(0xFFE6E7E8),
                    activeDotColor: primaryBlue,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),

                // Next or Start Button
                isLastPage
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                        child: Text("Start", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                      )
                    : IconButton(
                        onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                        icon: Icon(Icons.arrow_forward_rounded, color: primaryBlue, size: 30),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

