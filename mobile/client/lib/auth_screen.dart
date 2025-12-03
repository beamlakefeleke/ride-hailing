import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'signin_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.08, 16, 32);
    final extraLargeGap = clampDouble(size.height * 0.06, 28, 56);
    final largeGap = clampDouble(size.height * 0.05, 24, 44);
    final mediumGap = clampDouble(size.height * 0.035, 18, 32);
    final smallGap = clampDouble(size.height * 0.02, 10, 20);

    final logoSize = clampDouble(size.width * 0.24, 88, 128);
    final titleFontSize = clampDouble(size.width * 0.08, 26, 34);
    final subtitleFontSize = clampDouble(size.width * 0.045, 14, 18);
    final socialIconSize = clampDouble(size.width * 0.06, 22, 30);
    final socialSpacing = clampDouble(size.width * 0.03, 8, 16);
    final socialFontSize = clampDouble(size.width * 0.042, 14, 16);
    final primaryButtonPadding = clampDouble(size.height * 0.024, 14, 20);
    final secondaryButtonPadding = clampDouble(size.height * 0.022, 12, 18);
    final footerFontSize = clampDouble(size.width * 0.035, 12, 14);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = clampDouble(constraints.maxWidth * 0.9, 320, 500);

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: largeGap),
                      // Logo
                      CustomPaint(
                        size: Size(logoSize, logoSize),
                        painter: GoRideLogoPainter(),
                      ),
                      SizedBox(height: largeGap),
                      // Main Title
                      Text(
                        'Let\'s Get Started!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121), // Dark grey
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: smallGap),
                      // Subtitle
                      Text(
                        'Let\'s dive in into your account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: extraLargeGap),
                      // Social Login Options
                      _buildSocialButton(
                        context: context,
                        icon: _buildGoogleIcon(socialIconSize),
                        text: 'Continue with Google',
                        textSize: socialFontSize,
                        spacing: socialSpacing,
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
                          size: socialIconSize,
                        ),
                        text: 'Continue with Apple',
                        textSize: socialFontSize,
                        spacing: socialSpacing,
                        onPressed: () {
                          // Handle Apple login
                        },
                      ),
                      SizedBox(height: mediumGap),
                      _buildSocialButton(
                        context: context,
                        icon: Container(
                          width: socialIconSize,
                          height: socialIconSize,
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
                        spacing: socialSpacing,
                        onPressed: () {
                          // Handle Facebook login
                        },
                      ),
                      SizedBox(height: mediumGap),
                      _buildSocialButton(
                        context: context,
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                          size: socialIconSize,
                        ),
                        text: 'Continue with X',
                        textSize: socialFontSize,
                        spacing: socialSpacing,
                        onPressed: () {
                          // Handle X (Twitter) login
                        },
                      ),
                      SizedBox(height: extraLargeGap),
                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to Sign Up screen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SignUpScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: primaryButtonPadding,
                            ),
                            backgroundColor:
                                const Color(0xFF4CAF50), // Bright green
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to Sign In screen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SignInScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: secondaryButtonPadding,
                            ),
                            backgroundColor:
                                const Color(0xFF81C784), // Light green
                            foregroundColor:
                                const Color(0xFF4CAF50), // Bright green text
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: socialFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: extraLargeGap),
                      // Footer Links
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: socialSpacing / 2,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Handle Privacy Policy
                            },
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: footerFontSize,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: footerFontSize,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle Terms of Service
                            },
                            child: Text(
                              'Terms of Service',
                              style: TextStyle(
                                fontSize: footerFontSize,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: largeGap),
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

// Custom painter for GoRide logo (reused from splash screen)
class GoRideLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF50) // Green
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = const Color(0xFF4CAF50) // Green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw D shape (semicircle)
    final dPath = Path()
      ..moveTo(centerX - 20, centerY - 40)
      ..arcToPoint(
        Offset(centerX - 20, centerY + 40),
        radius: const Radius.circular(40),
        clockwise: false,
      )
      ..lineTo(centerX - 20, centerY - 40)
      ..close();
    canvas.drawPath(dPath, paint);

    // Draw inner circle
    canvas.drawCircle(Offset(centerX, centerY), 20, paint);

    // Draw three horizontal lines extending left
    final lineStartX = centerX - 20;
    canvas.drawLine(
      Offset(lineStartX, centerY - 10),
      Offset(lineStartX - 20, centerY - 10),
      strokePaint,
    );
    canvas.drawLine(
      Offset(lineStartX, centerY),
      Offset(lineStartX - 25, centerY),
      strokePaint,
    );
    canvas.drawLine(
      Offset(lineStartX, centerY + 10),
      Offset(lineStartX - 30, centerY + 10),
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for Google icon
class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Google G icon - simplified version
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

