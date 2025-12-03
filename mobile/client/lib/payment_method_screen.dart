import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int _selectedPaymentIndex = 0; // Default to GoRide Wallet

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'GoRide Wallet',
      'type': 'wallet',
      'subtitle': 'Available balance: \$2,069.50',
      'icon': Icons.account_balance_wallet,
      'iconColor': const Color(0xFF4CAF50),
      'backgroundColor': const Color(0xFF4CAF50),
    },
    {
      'name': 'Cash',
      'type': 'cash',
      'subtitle': 'Pay drivers cash directly',
      'icon': Icons.attach_money,
      'iconColor': const Color(0xFF4CAF50),
      'backgroundColor': Colors.white,
    },
    {
      'name': 'PayPal',
      'type': 'paypal',
      'subtitle': 'andrew.ainsley@yourdomain.com',
      'icon': Icons.payment,
      'iconColor': const Color(0xFF0070BA), // PayPal blue
      'backgroundColor': Colors.white,
      'isPayPal': true,
    },
    {
      'name': 'Google Pay',
      'type': 'google',
      'subtitle': 'andrew.ainsley@yourdomain.com',
      'icon': Icons.account_circle,
      'iconColor': Colors.black,
      'backgroundColor': Colors.white,
      'isGoogle': true,
    },
    {
      'name': 'Apple Pay',
      'type': 'apple',
      'subtitle': 'andrew.ainsley@yourdomain.com',
      'icon': Icons.apple,
      'iconColor': Colors.black,
      'backgroundColor': Colors.white,
      'isApple': true,
    },
    {
      'name': 'Mastercard',
      'type': 'card',
      'subtitle': '... ... ... 4679',
      'icon': Icons.credit_card,
      'iconColor': Colors.black,
      'backgroundColor': Colors.white,
      'isMastercard': true,
    },
  ];

  void _onOK() {
    Navigator.of(context).pop(_paymentMethods[_selectedPaymentIndex]);
  }

  void _onAddPayment() {
    // Handle add new payment method
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add payment method feature coming soon!'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 26);
    final paymentNameSize = clampDouble(size.width * 0.042, 14, 16);
    final paymentSubtitleSize = clampDouble(size.width * 0.035, 12, 14);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonPadding = clampDouble(size.height * 0.022, 14, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final paymentIconSize = clampDouble(size.width * 0.12, 50, 70);

    return Container(
      height: size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Drag Handle
            Container(
              margin: EdgeInsets.only(top: spacing * 0.5, bottom: spacing * 0.5),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Choose Payment Method',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.black87),
                    onPressed: _onAddPayment,
                  ),
                ],
              ),
            ),
            // Payment Methods List
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: spacing),
                    ...List.generate(_paymentMethods.length, (index) {
                      final payment = _paymentMethods[index];
                      final isSelected = _selectedPaymentIndex == index;
                      return Padding(
                        padding: EdgeInsets.only(bottom: spacing),
                        child: _buildPaymentCard(
                          payment,
                          isSelected,
                          paymentNameSize,
                          paymentSubtitleSize,
                          borderRadius,
                          spacing,
                          paymentIconSize,
                          iconSize,
                          () {
                            setState(() {
                              _selectedPaymentIndex = index;
                            });
                          },
                        ),
                      );
                    }),
                    SizedBox(height: spacing),
                  ],
                ),
              ),
            ),
            // OK Button
            Container(
              padding: EdgeInsets.all(horizontalPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onOK,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: buttonPadding),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(
    Map<String, dynamic> payment,
    bool isSelected,
    double nameSize,
    double subtitleSize,
    double borderRadius,
    double spacing,
    double iconSize,
    double checkIconSize,
    VoidCallback onTap,
  ) {
    final paymentType = payment['type'] as String;
    final iconColor = payment['iconColor'] as Color;
    final backgroundColor = payment['backgroundColor'] as Color;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4CAF50)
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Payment Icon
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: paymentType == 'wallet'
                    ? BorderRadius.circular(borderRadius * 0.5)
                    : BorderRadius.circular(iconSize / 2),
                border: paymentType == 'wallet'
                    ? null
                    : Border.all(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
              ),
              child: _buildPaymentIcon(
                payment,
                iconColor,
                iconSize,
              ),
            ),
            SizedBox(width: spacing),
            // Payment Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment['name'] as String,
                    style: TextStyle(
                      fontSize: nameSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: spacing * 0.25),
                  Text(
                    payment['subtitle'] as String,
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: spacing * 0.5),
            // Checkmark Icon (if selected)
            if (isSelected)
              Container(
                width: checkIconSize * 0.8,
                height: checkIconSize * 0.8,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: checkIconSize * 0.5,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentIcon(
    Map<String, dynamic> payment,
    Color iconColor,
    double size,
  ) {
    final paymentType = payment['type'] as String;

    if (payment['isPayPal'] == true) {
      // PayPal icon - blue circle with white P
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0070BA),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            'P',
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else if (payment['isGoogle'] == true) {
      // Google Pay icon - white circle with colored G
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Center(
          child: CustomPaint(
            size: Size(size * 0.7, size * 0.7),
            painter: GooglePayIconPainter(),
          ),
        ),
      );
    } else if (payment['isApple'] == true) {
      // Apple Pay icon - white circle with black Apple logo
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.apple,
            color: Colors.black,
            size: size * 0.6,
          ),
        ),
      );
    } else if (payment['isMastercard'] == true) {
      // Mastercard icon - overlapping circles
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Center(
          child: CustomPaint(
            size: Size(size * 0.8, size * 0.8),
            painter: MastercardIconPainter(),
          ),
        ),
      );
    } else if (paymentType == 'wallet') {
      // GoRide Wallet icon - green square with wallet icon and dash
      return Stack(
        children: [
          Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: size * 0.5,
          ),
          Positioned(
            top: size * 0.15,
            right: size * 0.15,
            child: Container(
              width: size * 0.2,
              height: 2,
              color: Colors.white,
            ),
          ),
        ],
      );
    } else {
      // Default icon (Cash)
      return Icon(
        payment['icon'] as IconData,
        color: iconColor,
        size: size * 0.6,
      );
    }
  }
}

// Custom painter for Google Pay icon
class GooglePayIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw colored G
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for Mastercard icon
class MastercardIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Red circle
    paint.color = const Color(0xFFEB001B);
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height / 2),
      size.width * 0.3,
      paint,
    );

    // Orange circle
    paint.color = const Color(0xFFF79E1B);
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height / 2),
      size.width * 0.3,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

