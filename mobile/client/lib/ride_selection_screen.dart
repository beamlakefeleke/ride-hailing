import 'package:flutter/material.dart';
import 'promos_screen.dart';
import 'payment_method_screen.dart';
import 'driver_search_screen.dart';
import 'schedule_ride_screen.dart';
import 'ride_scheduled_confirmation_screen.dart';

class RideSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> destination;
  final Map<String, dynamic> pickupLocation;

  const RideSelectionScreen({
    super.key,
    required this.destination,
    required this.pickupLocation,
  });

  @override
  State<RideSelectionScreen> createState() => _RideSelectionScreenState();
}

class _RideSelectionScreenState extends State<RideSelectionScreen> {
  int _selectedRideIndex = 0;
  Map<String, dynamic>? _selectedPromo;
  Map<String, dynamic>? _selectedPayment;
  DateTime? _scheduledDateTime;

  final List<Map<String, dynamic>> _rideOptions = [
    {
      'name': 'GoRide Car',
      'icon': Icons.directions_car,
      'arrival': '3-5 mins',
      'passengers': '4 passengers',
      'price': 12.50, // Original price as number
      'isXL': false,
      'isPlus': false,
    },
    {
      'name': 'GoRide Car XL',
      'icon': Icons.airport_shuttle,
      'arrival': '4-6 mins',
      'passengers': '6 passengers',
      'price': 15.00, // Original price as number
      'isXL': true,
      'isPlus': false,
    },
    {
      'name': 'GoRide Car Plus',
      'icon': Icons.directions_car,
      'arrival': '4-5 mins',
      'passengers': '4 passengers',
      'price': 16.50, // Original price as number (updated to match image)
      'isXL': false,
      'isPlus': true,
    },
  ];

  // Calculate discounted price
  double _getDiscountedPrice(double originalPrice) {
    if (_selectedPromo != null) {
      final title = _selectedPromo!['title'] as String;
      final match = RegExp(r'(\d+)%').firstMatch(title);
      if (match != null) {
        final discountPercent = double.parse(match.group(1)!);
        return originalPrice * (1 - discountPercent / 100);
      }
    }
    // Default 20% discount to match the image
    return originalPrice * 0.80;
  }

  // Format date for schedule button
  String _formatScheduleDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  // Format time for schedule button
  String _formatScheduleTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final priceFontSize = clampDouble(size.width * 0.045, 16, 18);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonPadding = clampDouble(size.height * 0.022, 14, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final cardIconSize = clampDouble(size.width * 0.1, 40, 50);

    return Container(
      height: size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: _buildBottomPanel(
        size,
        clampDouble,
        titleFontSize,
        priceFontSize,
        buttonFontSize,
        buttonPadding,
        borderRadius,
        spacing,
        iconSize,
        cardIconSize,
        horizontalPadding,
      ),
    );
  }

  Widget _buildBottomPanel(
    Size size,
    Function clampDouble,
    double titleFontSize,
    double priceFontSize,
    double buttonFontSize,
    double buttonPadding,
    double borderRadius,
    double spacing,
    double iconSize,
    double cardIconSize,
    double horizontalPadding,
  ) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: spacing * 0.5, bottom: spacing),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
                // Ride Options
                ...List.generate(_rideOptions.length, (index) {
                  final ride = _rideOptions[index];
                  final isSelected = _selectedRideIndex == index;
                  return Padding(
                    padding: EdgeInsets.only(bottom: spacing),
                    child: _buildRideOptionCard(
                      ride,
                      isSelected,
                      titleFontSize,
                      priceFontSize,
                      borderRadius,
                      spacing,
                      cardIconSize,
                      () {
                        setState(() {
                          _selectedRideIndex = index;
                        });
                      },
                    ),
                  );
                }),
                SizedBox(height: spacing),
                Divider(color: Colors.grey[300]),
                SizedBox(height: spacing),
                // Payment Method
                InkWell(
                  onTap: () async {
                    final selectedPayment = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const PaymentMethodScreen(),
                    );
                    if (selectedPayment != null) {
                      setState(() {
                        _selectedPayment = selectedPayment;
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing * 0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            color: const Color(0xFF212121),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              _selectedPayment?['name'] ?? 'GoRide Wallet',
                              style: TextStyle(
                                fontSize: titleFontSize,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(width: spacing * 0.5),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: iconSize * 0.5,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: spacing * 0.5),
                // Promos/Vouchers
                InkWell(
                  onTap: () async {
                    final selectedPromo = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const PromosScreen(),
                    );
                    if (selectedPromo != null) {
                      setState(() {
                        _selectedPromo = selectedPromo;
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing * 0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Promos / Vouchers',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            color: const Color(0xFF212121),
                          ),
                        ),
                        Row(
                          children: [
                            if (_selectedPromo != null) ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: spacing * 0.75,
                                  vertical: spacing * 0.25,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _selectedPromo!['code'] ?? 'EOYP25',
                                  style: TextStyle(
                                    fontSize: titleFontSize * 0.85,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: spacing * 0.5),
                            ],
                            Icon(
                              Icons.arrow_forward_ios,
                              size: iconSize * 0.5,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                // Action Buttons
                Row(
                  children: [
                    // Schedule Ride Button (shows date/time if scheduled)
                    _scheduledDateTime != null
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing * 0.75,
                              vertical: spacing * 0.5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatScheduleDate(_scheduledDateTime!),
                                  style: TextStyle(
                                    fontSize: buttonFontSize * 0.7,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _formatScheduleTime(_scheduledDateTime!),
                                  style: TextStyle(
                                    fontSize: buttonFontSize * 0.7,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: (clampDouble as dynamic)(size.width * 0.12, 48, 56) * 1.2,
                            height: (clampDouble as dynamic)(size.width * 0.12, 48, 56) * 1.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF4CAF50),
                                width: 2,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                color: const Color(0xFF4CAF50),
                                size: iconSize * 0.7,
                              ),
                              onPressed: () async {
                                final result = await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => ScheduleRideScreen(
                                    destination: widget.destination,
                                    pickupLocation: widget.pickupLocation,
                                    selectedRide: _rideOptions[_selectedRideIndex],
                                  ),
                                );
                                if (result != null && result['scheduled'] == true) {
                                  setState(() {
                                    _scheduledDateTime = result['dateTime'] as DateTime;
                                    // Auto-apply default promo when scheduling (matching the image)
                                    if (_selectedPromo == null) {
                                      _selectedPromo = {
                                        'title': 'Best Deal: 20% OFF',
                                        'code': 'EOYP25',
                                        'description': 'No min. spend',
                                        'validTill': 'Valid till 12/31/2024',
                                        'isBestDeal': true,
                                      };
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                    SizedBox(width: spacing),
                    // Book/Schedule Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_scheduledDateTime != null) {
                            // Navigate to scheduled confirmation screen
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => RideScheduledConfirmationScreen(
                                  scheduledDateTime: _scheduledDateTime!,
                                  destination: widget.destination,
                                  pickupLocation: widget.pickupLocation,
                                ),
                              ),
                            );
                          } else {
                            // Navigate to driver search screen for immediate booking
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => DriverSearchScreen(
                                  destination: widget.destination,
                                  pickupLocation: widget.pickupLocation,
                                  selectedRide: _rideOptions[_selectedRideIndex],
                                ),
                              ),
                            );
                          }
                        },
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
                          _scheduledDateTime != null
                              ? 'Schedule ${_rideOptions[_selectedRideIndex]['name']}'
                              : 'Book ${_rideOptions[_selectedRideIndex]['name']}',
                          style: TextStyle(
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),
              ],
            ),
          ),
        ),
      );
    
}

  Widget _buildRideOptionCard(
    Map<String, dynamic> ride,
    bool isSelected,
    double titleFontSize,
    double priceFontSize,
    double borderRadius,
    double spacing,
    double iconSize,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE8F5E9)
              : Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4CAF50)
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Car Icon
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(borderRadius * 0.5),
              ),
              child: Icon(
                ride['icon'] as IconData,
                color: const Color(0xFF4CAF50),
                size: iconSize * 0.6,
              ),
            ),
            SizedBox(width: spacing),
            // Ride Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ride['name'] as String,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: spacing * 0.25),
                  Row(
                    children: [
                      Text(
                        ride['arrival'] as String,
                        style: TextStyle(
                          fontSize: titleFontSize * 0.85,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: spacing * 0.5),
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: titleFontSize * 0.85,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: spacing * 0.5),
                      Text(
                        ride['passengers'] as String,
                        style: TextStyle(
                          fontSize: titleFontSize * 0.85,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Price with discount
            _selectedPromo != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Original price (crossed out)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${(ride['price'] as double).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: priceFontSize * 0.75,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[500],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: spacing * 0.25),
                          Icon(
                            Icons.check_circle,
                            size: priceFontSize * 0.6,
                            color: const Color(0xFF4CAF50),
                          ),
                        ],
                      ),
                      SizedBox(height: spacing * 0.25),
                      // Discounted price
                      Text(
                        '\$${_getDiscountedPrice(ride['price'] as double).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: priceFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                      ),
                    ],
                  )
                : Text(
                    '\$${(ride['price'] as double).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: priceFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for ride map with route
class RideMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw grid lines (streets)
    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint..color = Colors.grey[400]!.withOpacity(0.4),
      );
    }
    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint..color = Colors.grey[400]!.withOpacity(0.4),
      );
    }

    // Draw route line (green)
    final routePaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final startPoint = Offset(size.width * 0.45, size.height * 0.25);
    final endPoint = Offset(size.width * 0.5, size.height * 0.35);

    // Draw curved route
    final path = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..quadraticBezierTo(
        (startPoint.dx + endPoint.dx) / 2,
        (startPoint.dy + endPoint.dy) / 2 - 30,
        endPoint.dx,
        endPoint.dy,
      );

    canvas.drawPath(path, routePaint);

    // Draw street labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final streets = [
      {'name': 'W 9th St', 'y': size.height * 0.2},
      {'name': 'W 8th St', 'y': size.height * 0.25},
      {'name': 'W 4 St-Wash Sq', 'y': size.height * 0.3},
      {'name': '14 St', 'y': size.height * 0.4},
    ];

    final textStyle = TextStyle(
      color: Colors.grey[700],
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );

    for (final street in streets) {
      if (street.containsKey('y')) {
        textPainter.text = TextSpan(text: street['name'] as String, style: textStyle);
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(size.width * 0.05, street['y'] as double),
        );
      }
    }

    // Draw park area
    final parkPaint = Paint()
      ..color = Colors.green[100]!.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.3),
          width: size.width * 0.3,
          height: size.height * 0.15,
        ),
        const Radius.circular(8),
      ),
      parkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

