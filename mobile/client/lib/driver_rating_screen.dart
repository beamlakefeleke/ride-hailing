import 'package:flutter/material.dart';
import 'feedback_confirmation_screen.dart';

class DriverRatingScreen extends StatefulWidget {
  final Map<String, dynamic> driver;
  final Map<String, dynamic> selectedRide;
  final Map<String, dynamic>? selectedPayment;
  final Map<String, dynamic>? selectedPromo;

  const DriverRatingScreen({
    super.key,
    required this.driver,
    required this.selectedRide,
    this.selectedPayment,
    this.selectedPromo,
  });

  @override
  State<DriverRatingScreen> createState() => _DriverRatingScreenState();
}

class _DriverRatingScreenState extends State<DriverRatingScreen> {
  int _selectedRating = 0; // 0 means no rating selected
  bool _showDetails = true;

  // Calculate fare breakdown
  double get _tripFare {
    final price = widget.selectedRide['price'];
    if (price is double) {
      return price;
    } else if (price is String) {
      return double.parse(price.replaceAll('\$', '').replaceAll(',', ''));
    } else if (price is int) {
      return price.toDouble();
    }
    return 0.0; // Default fallback
  }

  double get _discountAmount {
    if (widget.selectedPromo != null) {
      final title = widget.selectedPromo!['title'] as String;
      final match = RegExp(r'(\d+)%').firstMatch(title);
      if (match != null) {
        final discountPercent = double.parse(match.group(1)!);
        return _tripFare * (discountPercent / 100);
      }
    }
    return _tripFare * 0.20; // Default 20% discount
  }

  double get _totalPaid {
    return _tripFare - _discountAmount;
  }

  String get _paymentMethod {
    return widget.selectedPayment?['name'] ?? 'GoRide Wallet';
  }

  String get _rideName {
    return widget.selectedRide['name'] ?? 'GoRide Car';
  }

  void _onGiveRate() {
    if (_selectedRating == 0) {
      // Show error if no rating selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // In real app, submit rating to backend
    // Navigate to feedback confirmation screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const FeedbackConfirmationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final subtitleFontSize = clampDouble(size.width * 0.038, 13, 15);
    final detailLabelFontSize = clampDouble(size.width * 0.038, 13, 15);
    final detailValueFontSize = clampDouble(size.width * 0.038, 13, 15);
    final totalFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final cardPadding = clampDouble(size.width * 0.04, 12, 16);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final profileSize = clampDouble(size.width * 0.25, 100, 140);
    final starSize = clampDouble(size.width * 0.08, 32, 48);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: spacing),
                // Close Button (Top Left)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black87),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: spacing),
                // Driver Profile Picture
                Container(
                  width: profileSize,
                  height: profileSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple[200],
                    border: Border.all(
                      color: Colors.purple[300]!,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: Container(
                      color: Colors.purple[200],
                      child: const Icon(
                        Icons.person,
                        color: Colors.purple,
                        size: 80,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                // Title
                Text(
                  'How was the driver?',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing * 0.5),
                // Subtitle
                Text(
                  'Help GoRide do better by rating this trip',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing * 1.5),
                // Star Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRating = index + 1;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: clampDouble(size.width * 0.02, 4, 8),
                        ),
                        child: Icon(
                          index < _selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          size: starSize,
                          color: index < _selectedRating
                              ? Colors.amber
                              : Colors.grey[400],
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: spacing * 2),
                // Ride and Payment Details
                _buildDetailsCard(
                  size,
                  clampDouble,
                  detailLabelFontSize,
                  detailValueFontSize,
                  spacing,
                  cardPadding,
                  borderRadius,
                ),
                SizedBox(height: spacing),
                // Fare Breakdown (Collapsible)
                if (_showDetails)
                  _buildFareBreakdownCard(
                    size,
                    clampDouble,
                    detailLabelFontSize,
                    detailValueFontSize,
                    totalFontSize,
                    spacing,
                    cardPadding,
                    borderRadius,
                  ),
                SizedBox(height: spacing * 0.5),
                // Hide Details Link
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showDetails = !_showDetails;
                    });
                  },
                  child: Text(
                    _showDetails ? 'Hide details' : 'Show details',
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      color: const Color(0xFF4CAF50),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: spacing * 2),
                // Give Rate Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onGiveRate,
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
                      'Give Rate',
                      style: TextStyle(
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard(
    Size size,
    Function clampDouble,
    double labelFontSize,
    double valueFontSize,
    double spacing,
    double cardPadding,
    double borderRadius,
  ) {
    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Ride row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ride',
                style: TextStyle(
                  fontSize: labelFontSize,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                _rideName,
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF212121),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing * 0.75),
          // Payment row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment',
                style: TextStyle(
                  fontSize: labelFontSize,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                _paymentMethod,
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF212121),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFareBreakdownCard(
    Size size,
    Function clampDouble,
    double labelFontSize,
    double valueFontSize,
    double totalFontSize,
    double spacing,
    double cardPadding,
    double borderRadius,
  ) {
    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Trip Fare row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trip Fare',
                style: TextStyle(
                  fontSize: labelFontSize,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '\$${_tripFare.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF212121),
                ),
              ),
            ],
          ),
          if (_discountAmount > 0) ...[
            SizedBox(height: spacing * 0.75),
            // Discount row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discounts (20%)',
                  style: TextStyle(
                    fontSize: labelFontSize,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '- \$${_discountAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: spacing * 0.75),
          Divider(color: Colors.grey[300], height: 1),
          SizedBox(height: spacing * 0.75),
          // Total Paid row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Paid',
                style: TextStyle(
                  fontSize: totalFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
              Text(
                '\$${_totalPaid.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: totalFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

