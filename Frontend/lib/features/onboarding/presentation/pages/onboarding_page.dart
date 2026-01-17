import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/providers/shared_preferences_provider.dart'; // Import provider
import '../../../../features/auth/presentation/pages/login_page.dart';
import '../widgets/onboarding_content.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  final List<Map<String, String>> _pages = [
    { "image": "assets/images/milk.jpg", "title": "Fresh from Farm", "desc": "Get fresh milk delivered directly from local farmers." },
    { "image": "assets/images/cheese.png", "title": "Organic Products", "desc": "Enjoy 100% organic dairy products without preservatives." },
    { "image": "assets/images/butter.jpg", "title": "Fast Delivery", "desc": "We ensure delivery within 24 hours of milking." },
  ];

  // --- NEW FUNCTION TO SAVE FLAG ---
  void _completeOnboarding() async {
    final prefs = ref.read(sharedPreferencesProvider);
    // This saves "true" to disk
    await prefs.setBool('is_onboarding_completed', true);

    if (mounted) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const LoginPage())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF29ABE2);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // CAROUSEL
            Positioned.fill(
              bottom: 100,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => isLastPage = index == _pages.length - 1),
                itemCount: _pages.length,
                itemBuilder: (context, index) => OnboardingContent(
                  image: _pages[index]["image"]!,
                  title: _pages[index]["title"]!,
                  description: _pages[index]["desc"]!,
                ),
              ),
            ),

            // BOTTOM CONTROLS
            Positioned(
              bottom: 40,
              left: 30,
              right: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: const ExpandingDotsEffect(activeDotColor: primaryBlue, dotHeight: 8, dotWidth: 8),
                  ),
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)
                    ),
                    onPressed: () {
                      if (isLastPage) {
                        // --- CALL THE SAVE FUNCTION HERE ---
                        _completeOnboarding();
                      } else {
                        _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                      }
                    },
                    child: Text(
                      isLastPage ? "Get Started" : "Next",
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}