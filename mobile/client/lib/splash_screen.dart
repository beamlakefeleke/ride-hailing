import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to onboarding after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();
    final heightScale = clampDouble(size.height / 720, 0.55, 1.0);

    final logoSize =
        clampDouble(size.width * 0.3 * heightScale, 64, 140);
    final titleFontSize =
        clampDouble(size.width * 0.1 * heightScale, 20, 36);
    final verticalGap =
        clampDouble(size.height * 0.02 * heightScale, 8, 24);
    final bottomPadding =
        clampDouble(size.height * 0.06 * heightScale, 18, 64);
    final progressSize =
        clampDouble(size.width * 0.12 * heightScale, 24, 48);

    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50), // Green background
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompactHeight = constraints.maxHeight < 400;
            final splashContent = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomPaint(
                  size: Size(logoSize, logoSize),
                  painter: GoRideLogoPainter(),
                ),
                SizedBox(height: verticalGap),
                Text(
                  'GoRide',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            );

            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: isCompactHeight
                        ? SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              vertical: clampDouble(
                                size.height * 0.05,
                                16,
                                32,
                              ),
                            ),
                            child: splashContent,
                          )
                        : splashContent,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: SizedBox(
                    width: progressSize,
                    height: progressSize,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Custom painter for GoRide logo
class GoRideLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white
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

    // Draw small target icon below
    final targetY = centerY + 45;
    final targetPaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, targetY), 5, targetPaint);
    
    final targetStroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(centerX - 5, targetY),
      Offset(centerX + 5, targetY),
      targetStroke,
    );
    canvas.drawLine(
      Offset(centerX, targetY - 5),
      Offset(centerX, targetY + 5),
      targetStroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

