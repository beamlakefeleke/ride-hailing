import 'package:flutter/material.dart';
import 'home_page.dart';

class RideCancellationConfirmationScreen extends StatelessWidget {
  const RideCancellationConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final messageFontSize = clampDouble(size.width * 0.038, 13, 15);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final checkmarkSize = clampDouble(size.width * 0.25, 100, 140);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Close Button
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () {
                      // Navigate back to home page
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const MyHomePage(title: 'GoRide'),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
            // Main Content
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Green Checkmark Icon
                      Container(
                        width: checkmarkSize,
                        height: checkmarkSize,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                      SizedBox(height: spacing * 2),
                      // Primary Message
                      Text(
                        'Ride has been canceled!',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing * 1.5),
                      // Explanation Message
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding * 0.5,
                        ),
                        child: Text(
                          'Funds have been returned to your account. You can see the cancellation history in the activity menu.',
                          style: TextStyle(
                            fontSize: messageFontSize,
                            color: const Color(0xFF212121),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // OK Button
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to home page
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const MyHomePage(title: 'GoRide'),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: clampDouble(size.height * 0.022, 16, 20),
                    ),
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: spacing),
          ],
        ),
      ),
    );
  }
}

