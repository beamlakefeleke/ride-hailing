import 'package:flutter/material.dart';
import 'dart:ui';

class ChooseTopUpMethodScreen extends StatefulWidget {
  final double amount;

  const ChooseTopUpMethodScreen({
    Key? key,
    required this.amount,
  }) : super(key: key);

  @override
  State<ChooseTopUpMethodScreen> createState() => _ChooseTopUpMethodScreenState();
}

class _ChooseTopUpMethodScreenState extends State<ChooseTopUpMethodScreen> {
  int _selectedMethodIndex = 3; // Mastercard is selected by default

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'PayPal',
      'icon': Icons.payment,
      'iconColor': Colors.blue[700]!,
      'iconBgColor': Colors.blue[50],
      'details': 'andrew.ainsley@yourdomain.com',
      'type': 'email',
    },
    {
      'name': 'Google Pay',
      'icon': Icons.account_circle,
      'iconColor': Colors.blue,
      'iconBgColor': Colors.blue[50],
      'details': 'andrew.ainsley@yourdomain.com',
      'type': 'email',
    },
    {
      'name': 'Apple Pay',
      'icon': Icons.apple,
      'iconColor': Colors.black,
      'iconBgColor': Colors.grey[100]!,
      'details': 'andrew.ainsley@yourdomain.com',
      'type': 'email',
    },
    {
      'name': 'Mastercard',
      'icon': Icons.credit_card,
      'iconColor': Colors.orange,
      'iconBgColor': Colors.orange[50]!,
      'details': '.... .... .... 4679',
      'type': 'card',
    },
    {
      'name': 'Visa',
      'icon': Icons.credit_card,
      'iconColor': Colors.blue[900]!,
      'iconBgColor': Colors.blue[50],
      'details': '.... .... .... 5567',
      'type': 'card',
    },
    {
      'name': 'American Express',
      'icon': Icons.credit_card,
      'iconColor': Colors.blue[800]!,
      'iconBgColor': Colors.blue[50],
      'details': '.... .... .... 8456',
      'type': 'card',
    },
  ];

  void _onConfirmTopUp() {
    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TopUpSuccessDialog(amount: widget.amount),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final listItemTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final listItemSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context, size, clampDouble, titleFontSize, horizontalPadding),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(horizontalPadding),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                final isSelected = _selectedMethodIndex == index;
                return Padding(
                  padding: EdgeInsets.only(bottom: spacing),
                  child: _buildPaymentMethodCard(
                    size,
                    clampDouble,
                    method,
                    isSelected,
                    listItemTitleFontSize,
                    listItemSubtitleFontSize,
                    spacing,
                    borderRadius,
                    index,
                  ),
                );
              },
            ),
          ),
          // Confirm Button
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
                  onPressed: _onConfirmTopUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: EdgeInsets.symmetric(
                      vertical: clampDouble(size.height * 0.02, 14, 18),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Confirm Top Up - \$${widget.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    Size size,
    Function clampDouble,
    double titleFontSize,
    double horizontalPadding,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Choose Top Up Method',
        style: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF212121),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: Color(0xFF212121)),
          onPressed: () {
            // Add new payment method
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add payment method'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(
    Size size,
    Function clampDouble,
    Map<String, dynamic> method,
    bool isSelected,
    double titleFontSize,
    double subtitleFontSize,
    double spacing,
    double borderRadius,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethodIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(clampDouble(size.width * 0.05, 16, 24)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: clampDouble(size.width * 0.14, 48, 56),
              height: clampDouble(size.width * 0.14, 48, 56),
              decoration: BoxDecoration(
                color: method['iconBgColor'] as Color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                method['icon'] as IconData,
                color: method['iconColor'] as Color,
                size: clampDouble(size.width * 0.06, 22, 28),
              ),
            ),
            SizedBox(width: spacing),
            // Name and Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['name'] as String,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: spacing * 0.25),
                  Text(
                    method['details'] as String,
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Checkmark (if selected)
            if (isSelected)
              Container(
                width: clampDouble(size.width * 0.08, 28, 32),
                height: clampDouble(size.width * 0.08, 28, 32),
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TopUpSuccessDialog extends StatelessWidget {
  final double amount;

  const TopUpSuccessDialog({
    Key? key,
    required this.amount,
  }) : super(key: key);

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
    final iconSize = clampDouble(size.width * 0.2, 60, 80);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius * 2),
        ),
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding * 1.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: spacing),
              // Success Icon
              Container(
                width: iconSize,
                height: iconSize,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              SizedBox(height: spacing * 1.5),
              // Title
              Text(
                'Top Up Successful!',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing),
              // Message
              Text(
                'You\'ve successfully added \$${amount.toStringAsFixed(2)} to your GoRide Wallet.',
                style: TextStyle(
                  fontSize: messageFontSize,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing * 2),
              // OK Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to previous screen
                    Navigator.of(context).pop(); // Go back to Account screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: EdgeInsets.symmetric(
                      vertical: clampDouble(size.height * 0.02, 14, 18),
                    ),
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing),
            ],
          ),
        ),
      ),
    );
  }
}

