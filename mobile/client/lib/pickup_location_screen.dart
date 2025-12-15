import 'package:flutter/material.dart';
import 'features/location/presentation/pages/pickup_location_page.dart';

class PickupLocationScreen extends StatelessWidget {
  final Map<String, dynamic> destination;

  const PickupLocationScreen({
    super.key,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return PickupLocationPage(destination: destination);
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
