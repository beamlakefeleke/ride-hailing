import 'package:flutter/material.dart';
import 'ride_selection_screen.dart';

class PickupLocationScreen extends StatefulWidget {
  final Map<String, dynamic> destination;

  const PickupLocationScreen({
    super.key,
    required this.destination,
  });

  @override
  State<PickupLocationScreen> createState() => _PickupLocationScreenState();
}

class _PickupLocationScreenState extends State<PickupLocationScreen> {
  Map<String, dynamic> _pickupLocation = {
    'name': 'Bobst Library',
    'address': '70 Washington Square S, New York, NY 10...',
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.048, 18, 22);
    final locationNameSize = clampDouble(size.width * 0.042, 14, 16);
    final addressSize = clampDouble(size.width * 0.035, 12, 14);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonPadding = clampDouble(size.height * 0.022, 14, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);

    return Container(
      height: size.height * 0.5,
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
        locationNameSize,
        addressSize,
        buttonFontSize,
        buttonPadding,
        borderRadius,
        spacing,
        iconSize,
        horizontalPadding,
      ),
    );
  }

  Widget _buildBottomPanel(
    Size size,
    Function clampDouble,
    double titleFontSize,
    double locationNameSize,
    double addressSize,
    double buttonFontSize,
    double buttonPadding,
    double borderRadius,
    double spacing,
    double iconSize,
    double horizontalPadding,
  ) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: spacing),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            SizedBox(height: spacing * 0.5),

            // Title
            Text(
              'Set pickup location',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),

            SizedBox(height: spacing),

            // Selected Location Card
            Container(
              padding: EdgeInsets.all(spacing),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Location Icon
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: Icon(
                      Icons.location_on,
                      size: iconSize * 0.6,
                      color: Colors.grey[600],
                    ),
                  ),

                  SizedBox(width: spacing),

                  // Location Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _pickupLocation['name'] as String,
                          style: TextStyle(
                            fontSize: locationNameSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF212121),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: spacing * 0.25),
                        Text(
                          _pickupLocation['address'] as String,
                          style: TextStyle(
                            fontSize: addressSize,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: spacing * 0.5),

                  // Edit Button
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey[600],
                      size: iconSize * 0.8,
                    ),
                    onPressed: () {
                      // You can add location editing logic here
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: spacing * 1.5),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => RideSelectionScreen(
                      destination: widget.destination,
                      pickupLocation: _pickupLocation,
                    ),
                  );
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
                  'Next',
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
    );
  }
}

// Custom pickup map painter
class PickupMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Grid (streets)
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

    // Street labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final streets = [
      {'name': 'E 10th St', 'y': size.height * 0.3},
      {'name': 'E 9th St', 'y': size.height * 0.35},
      {'name': 'E 8th St', 'y': size.height * 0.4},
      {'name': 'W 3rd St', 'y': size.height * 0.55},
      {'name': 'LaGuardia Pl', 'x': size.width * 0.3},
      {'name': 'W Houston St', 'y': size.height * 0.65},
      {'name': 'Bond St', 'x': size.width * 0.7},
    ];

    final textStyle = TextStyle(
      color: Colors.grey[700],
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );

    for (final street in streets) {
      textPainter.text =
          TextSpan(text: street['name'] as String, style: textStyle);
      textPainter.layout();

      if (street.containsKey('y')) {
        textPainter.paint(
          canvas,
          Offset(size.width * 0.05, street['y'] as double),
        );
      } else {
        canvas.save();
        canvas.translate(street['x'] as double, size.height * 0.5);
        canvas.rotate(-1.57);
        textPainter.paint(canvas, Offset.zero);
        canvas.restore();
      }
    }

    // Washington Square Park rectangle
    final parkPaint = Paint()
      ..color = Colors.green[100]!.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.4),
          width: size.width * 0.3,
          height: size.height * 0.2,
        ),
        const Radius.circular(8),
      ),
      parkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
