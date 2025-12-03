import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'signin_screen.dart';
import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _agreeToTerms = false;
  String _selectedCountryCode = '+1'; // Default to US

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.08, 16, 28);
    final maxContentWidth = clampDouble(size.width * 0.9, 320, 520);
    final topPadding = clampDouble(size.height * 0.02, 12, 28);
    final largeGap = clampDouble(size.height * 0.04, 20, 36);
    final mediumGap = clampDouble(size.height * 0.03, 16, 28);
    final smallGap = clampDouble(size.height * 0.02, 12, 22);
    final tinyGap = clampDouble(size.height * 0.015, 8, 16);

    final titleFontSize = clampDouble(size.width * 0.072, 22, 30);
    final subtitleFontSize = clampDouble(size.width * 0.042, 14, 18);
    final labelFontSize = clampDouble(size.width * 0.04, 14, 18);
    final helperFontSize = clampDouble(size.width * 0.035, 12, 15);
    final socialFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonPadding = clampDouble(size.height * 0.022, 14, 20);
    final dividerFontSize = clampDouble(size.width * 0.035, 12, 14);
    final iconSize = clampDouble(size.width * 0.06, 22, 30);
    final sparkleSize = clampDouble(size.width * 0.05, 18, 24);
    final checkboxSize = clampDouble(size.width * 0.065, 20, 26);
    final borderRadius = clampDouble(size.width * 0.04, 10, 14);
    final spacingBetweenIconAndText = clampDouble(size.width * 0.03, 8, 16);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: topPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Arrow
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black87),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      SizedBox(height: tinyGap),
                      // Title with sparkle icons
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Join GoRide Today',
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF212121), // Dark grey
                                height: 1.2,
                              ),
                            ),
                          ),
                          // Sparkle icons
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber[400],
                                size: sparkleSize,
                              ),
                              SizedBox(width: spacingBetweenIconAndText / 2),
                              Icon(
                                Icons.star,
                                color: Colors.amber[400],
                                size: sparkleSize,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: smallGap),
                      // Subtitle
                      Text(
                        'Let\'s get started! Enter your phone number to create your GoRide account.',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: largeGap),
                      // Phone Number Label
                      Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF212121), // Dark grey
                        ),
                      ),
                      SizedBox(height: smallGap),
                      // Phone Number Input Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Country Code Selector
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: spacingBetweenIconAndText,
                                vertical: spacingBetweenIconAndText / 2,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Flag icon (using emoji or icon)
                                  Container(
                                    width: iconSize,
                                    height: iconSize,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.blue[900],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '🇺🇸',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: spacingBetweenIconAndText / 1.5),
                                  // Country code dropdown
                                  DropdownButton<String>(
                                    value: _selectedCountryCode,
                                    underline: const SizedBox(),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey[600],
                                      size: iconSize,
                                    ),
                                    items: const [
                                      DropdownMenuItem(value: '+1', child: Text('+1')),
                                      DropdownMenuItem(value: '+44', child: Text('+44')),
                                      DropdownMenuItem(value: '+91', child: Text('+91')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCountryCode = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // Phone Number Input
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'Phone Number',
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: spacingBetweenIconAndText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: mediumGap),
                      // Terms & Conditions Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: checkboxSize,
                            height: checkboxSize,
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(
                                color: Color(0xFF4CAF50),
                                width: 2,
                              ),
                            ),
                          ),
                          SizedBox(width: spacingBetweenIconAndText),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: helperFontSize,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                                children: [
                                  const TextSpan(text: 'I agree to GoRide '),
                                  TextSpan(
                                    text: 'Terms & Conditions.',
                                    style: const TextStyle(
                                      color: Color(0xFF4CAF50),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Handle Terms & Conditions tap
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: mediumGap),
                      // Already have an account?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: helperFontSize,
                              color: Colors.grey[600],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to sign in screen
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const SignInScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: helperFontSize,
                                color: const Color(0xFF4CAF50),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: largeGap),
                      // Separator with "or"
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacingBetweenIconAndText,
                            ),
                            child: Text(
                              'or',
                              style: TextStyle(
                                fontSize: dividerFontSize,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: largeGap),
                      // Social Login Buttons
                      _buildSocialButton(
                        context: context,
                        icon: _buildGoogleIcon(iconSize),
                        text: 'Continue with Google',
                        textSize: socialFontSize,
                        spacing: spacingBetweenIconAndText,
                        onPressed: () {
                          // Handle Google login
                        },
                      ),
                      SizedBox(height: mediumGap),
                      _buildSocialButton(
                        context: context,
                        icon: Icon(
                          Icons.apple,
                          color: Colors.black,
                          size: iconSize,
                        ),
                        text: 'Continue with Apple',
                        textSize: socialFontSize,
                        spacing: spacingBetweenIconAndText,
                        onPressed: () {
                          // Handle Apple login
                        },
                      ),
                      SizedBox(height: mediumGap),
                      _buildSocialButton(
                        context: context,
                        icon: Container(
                          width: iconSize,
                          height: iconSize,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1877F2), // Facebook blue
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'f',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        text: 'Continue with Facebook',
                        textSize: socialFontSize,
                        spacing: spacingBetweenIconAndText,
                        onPressed: () {
                          // Handle Facebook login
                        },
                      ),
                      SizedBox(height: largeGap),
                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _agreeToTerms && _phoneController.text.isNotEmpty
                              ? () {
                                  // Navigate to OTP screen
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => OtpScreen(
                                        phoneNumber: _phoneController.text,
                                        countryCode: _selectedCountryCode,
                                        isSignUp: true,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: buttonPadding),
                            backgroundColor:
                                const Color(0xFF4CAF50), // Bright green
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            disabledForegroundColor: Colors.grey[500],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: socialFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: mediumGap),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required Widget icon,
    required String text,
    required double textSize,
    required double spacing,
    required VoidCallback onPressed,
  }) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();
    final verticalPadding = clampDouble(size.height * 0.02, 12, 18);

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          side: BorderSide(
            color: Colors.grey[300]!,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(width: spacing),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF212121), // Dark grey
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleIcon(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: GoogleIconPainter(),
      ),
    );
  }
}

// Custom painter for Google icon
class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Blue section
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -1.57, // -90 degrees
      1.57, // 90 degrees
      true,
      paint,
    );

    // Red section
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0, // 0 degrees
      1.57, // 90 degrees
      true,
      paint,
    );

    // Yellow section
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      1.57, // 90 degrees
      1.57, // 90 degrees
      true,
      paint,
    );

    // Green section
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      3.14, // 180 degrees
      1.57, // 90 degrees
      true,
      paint,
    );

    // White center circle
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.35,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

