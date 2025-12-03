import 'package:flutter/material.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  double _clamp(double value, double min, double max) =>
      value.clamp(min, max).toDouble();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onContinue() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToHome();
    }
  }

  void _onSkip() {
    _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = _clamp(size.width * 0.08, 16, 28);
    final verticalPadding = _clamp(size.height * 0.035, 18, 32);
    final indicatorSpacing = _clamp(size.width * 0.02, 4, 10);
    final indicatorHeight = _clamp(size.height * 0.012, 6, 10);
    final indicatorWidthActive = _clamp(size.width * 0.12, 18, 32);
    final indicatorSizeInactive = _clamp(size.width * 0.024, 6, 10);
    final buttonSpacing = _clamp(size.width * 0.04, 12, 20);
    final outlinedPadding = _clamp(size.height * 0.02, 12, 18);
    final filledPadding = _clamp(size.height * 0.024, 14, 20);
    final buttonFontSize = _clamp(size.width * 0.042, 14, 16);
    final headingFontSize = _clamp(size.width * 0.068, 22, 30);
    final subheadingFontSize = _clamp(size.width * 0.06, 20, 26);
    final bodyFontSize = _clamp(size.width * 0.04, 14, 18);
    final contentSpacing = _clamp(size.height * 0.03, 16, 28);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Map View Section (2/3 of screen) - Green background placeholder
            Expanded(
              flex: 2,
              child: ClipPath(
                clipper: CurvedBottomClipper(),
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFF4CAF50), // Green background
                ),
              ),
            ),
            // Onboarding Content Section (1/3 of screen)
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page Content
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        children: [
                          // Page 1: Welcome
                          _buildOnboardingPage(
                            context: context,
                            title: 'Welcome to GoRide - Your Journey, Your Way',
                            description:
                                'Get ready to experience hassle-free transportation. We\'ve got everything you need to travel with ease. Let\'s get started!',
                            titleFontSize: headingFontSize,
                            bodyFontSize: bodyFontSize,
                            alignment: CrossAxisAlignment.start,
                            textAlign: TextAlign.start,
                            spacing: contentSpacing,
                          ),
                          // Page 2: Choose Your Ride
                          _buildOnboardingPage2(
                            context: context,
                            headingFontSize: headingFontSize,
                            subheadingFontSize: subheadingFontSize,
                            bodyFontSize: bodyFontSize,
                            spacing: contentSpacing,
                          ),
                          // Page 3: Secure Payments
                          _buildOnboardingPage3(
                            context: context,
                            headingFontSize: headingFontSize,
                            bodyFontSize: bodyFontSize,
                            spacing: contentSpacing,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: contentSpacing / 1.5),
                    // Pagination Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _totalPages,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.symmetric(horizontal: indicatorSpacing / 2),
                          width: index == _currentPage
                              ? indicatorWidthActive
                              : indicatorSizeInactive,
                          height: indicatorHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(indicatorHeight),
                            color: index == _currentPage
                                ? const Color(0xFF4CAF50)
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: contentSpacing),
                    // Action Buttons
                    if (_currentPage == _totalPages - 1)
                      // Last page: Single "Let's Get Started" button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onContinue,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: filledPadding),
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Let\'s Get Started',
                            style: TextStyle(
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else
                      // Other pages: Skip and Continue buttons
                      Row(
                        children: [
                          // Skip Button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _onSkip,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: outlinedPadding),
                                side: const BorderSide(
                                  color: Color(0xFF81C784), // Light green border
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                  color: const Color(0xFF4CAF50), // Green text
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: buttonSpacing),
                          // Continue Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _onContinue,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: filledPadding),
                                backgroundColor: const Color(0xFF4CAF50), // Vibrant green
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({
    required BuildContext context,
    required String title,
    required String description,
    required double titleFontSize,
    required double bodyFontSize,
    required CrossAxisAlignment alignment,
    required TextAlign textAlign,
    required double spacing,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final content = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: alignment,
          children: [
            Text(
              title,
              textAlign: textAlign,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
            SizedBox(height: spacing / 2),
            Text(
              description,
              textAlign: textAlign,
              style: TextStyle(
                fontSize: bodyFontSize,
                color: Colors.black87.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ],
        );

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Align(
              alignment: alignment == CrossAxisAlignment.start
                  ? Alignment.centerLeft
                  : Alignment.center,
              child: content,
            ),
          ),
        );
      },
    );
  }

  // Page 2: Choose Your Ride
  Widget _buildOnboardingPage2({
    required BuildContext context,
    required double headingFontSize,
    required double subheadingFontSize,
    required double bodyFontSize,
    required double spacing,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final content = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Your Ride -',
              style: TextStyle(
                fontSize: headingFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
            SizedBox(height: spacing / 3),
            Text(
              'Tailored to Your Needs',
              style: TextStyle(
                fontSize: subheadingFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
            SizedBox(height: spacing / 2),
            Text(
              'Select your preferred mode of transportation - motorbike / scooter, or car - and order a ride with just a few taps.',
              style: TextStyle(
                fontSize: bodyFontSize,
                color: Colors.black87.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ],
        );

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Align(
              alignment: Alignment.centerLeft,
              child: content,
            ),
          ),
        );
      },
    );
  }

  // Page 3: Secure Payments
  Widget _buildOnboardingPage3({
    required BuildContext context,
    required double headingFontSize,
    required double bodyFontSize,
    required double spacing,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final content = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Secure Payments & Seamless Transactions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: headingFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
            SizedBox(height: spacing / 2),
            Text(
              'Say hello to convenience payments. Pay for your rides securely using GoRide Wallet, PayPal, Google Pay, Apple Pay, card, and or cash.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: bodyFontSize,
                color: Colors.black87.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ],
        );

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Align(
              alignment: Alignment.center,
              child: content,
            ),
          ),
        );
      },
    );
  }
}

// Custom clipper for curved bottom of map section
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

