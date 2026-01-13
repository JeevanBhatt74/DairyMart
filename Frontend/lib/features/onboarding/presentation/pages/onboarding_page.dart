import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/onboarding_content.dart';
import '../../../../features/auth/presentation/pages/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  final List<Map<String, String>> _pages = [
    {
      "image": "assets/images/milk.jpg", 
      "title": "Fresh from Farm",
      "desc": "Get fresh milk delivered directly from local farmers to your doorstep every morning."
    },
    {
      "image": "assets/images/cheese.png", 
      "title": "Organic Products",
      "desc": "Enjoy 100% organic dairy products like Cheese, Paneer, and Ghee without preservatives."
    },
    {
      "image": "assets/images/butter.jpg", 
      "title": "Fast Delivery",
      "desc": "We ensure delivery within 24 hours of milking to guarantee the best quality."
    },
    {
      "image": "assets/images/ghee.png", 
      "title": "Pure & Healthy",
      "desc": "Experience the rich taste and health benefits of our traditional, pure ghee."
    },
  ];

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF29ABE2);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // --- CAROUSEL CONTENT ---
            Positioned.fill(
              bottom: 100, // Leave space for bottom controls
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

            // --- BOTTOM CONTROLS (Floating Effect) ---
            Positioned(
              bottom: 40,
              left: 30,
              right: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 1. DYNAMIC DOTS INDICATOR
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: primaryBlue,
                      dotColor: Colors.grey.shade300,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3, // Wide pill effect for active dot
                      spacing: 8,
                    ),
                  ),

                  // 2. MODERN FLOATING BUTTON
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      elevation: 8, // Nice shadow depth
                      shadowColor: primaryBlue.withOpacity(0.5), // Colored shadow
                      shape: const StadiumBorder(), // Pill shape
                    ),
                    onPressed: () {
                      if (isLastPage) {
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(builder: (context) => const LoginPage())
                        );
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400), 
                          curve: Curves.easeInOut
                        );
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isLastPage ? "Get Started" : "Next",
                          style: GoogleFonts.poppins(
                            fontSize: 16, 
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isLastPage ? Icons.check_circle_outline : Icons.arrow_forward_rounded,
                          size: 20,
                        ),
                      ],
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