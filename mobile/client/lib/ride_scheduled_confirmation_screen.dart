import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'home_page.dart';

class RideScheduledConfirmationScreen extends StatelessWidget {
  final DateTime scheduledDateTime;
  final Map<String, dynamic> destination;
  final Map<String, dynamic> pickupLocation;

  const RideScheduledConfirmationScreen({
    super.key,
    required this.scheduledDateTime,
    required this.destination,
    required this.pickupLocation,
  });

  String _formatScheduledDate(DateTime date) {
    final weekday = DateFormat('EEEE').format(date); // Full weekday name
    final month = DateFormat('MMM').format(date); // Short month name
    final day = date.day;
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$weekday, $month $day - $displayHour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final dateFontSize = clampDouble(size.width * 0.042, 14, 16);
    final messageFontSize = clampDouble(size.width * 0.038, 13, 15);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final iconSize = clampDouble(size.width * 0.2, 80, 120);

    // Default coordinates
    final pickupLatLng = pickupLocation['lat'] != null &&
            pickupLocation['lng'] != null
        ? LatLng(
            pickupLocation['lat'] as double,
            pickupLocation['lng'] as double,
          )
        : const LatLng(40.7295, -73.9965);

    final dropoffLatLng = destination['lat'] != null &&
            destination['lng'] != null
        ? LatLng(
            destination['lat'] as double,
            destination['lng'] as double,
          )
        : const LatLng(40.7308, -73.9973);

    return Scaffold(
      body: Stack(
        children: [
          // Blurred Map Background
          _buildBlurredMapBackground(pickupLatLng, dropoffLatLng),
          // Confirmation Modal
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildConfirmationModal(
              size,
              clampDouble,
              horizontalPadding,
              titleFontSize,
              dateFontSize,
              messageFontSize,
              buttonFontSize,
              spacing,
              borderRadius,
              iconSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurredMapBackground(LatLng pickup, LatLng dropoff) {
    return Stack(
      children: [
        // Map
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              (pickup.latitude + dropoff.latitude) / 2,
              (pickup.longitude + dropoff.longitude) / 2,
            ),
            zoom: 14.0,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('pickup'),
              position: pickup,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow(
                title: pickupLocation['name'] ?? 'Pickup',
              ),
            ),
            Marker(
              markerId: const MarkerId('dropoff'),
              position: dropoff,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              infoWindow: InfoWindow(
                title: destination['name'] ?? 'Destination',
              ),
            ),
          },
          polylines: {
            Polyline(
              polylineId: const PolylineId('route'),
              points: [pickup, dropoff],
              color: const Color(0xFF4CAF50),
              width: 4,
            ),
          },
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: false,
        ),
        // Blur overlay
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationModal(
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double titleFontSize,
    double dateFontSize,
    double messageFontSize,
    double buttonFontSize,
    double spacing,
    double borderRadius,
    double iconSize,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: spacing),
              // Calendar Icon (overlapping the map)
              Transform.translate(
                offset: Offset(0, -iconSize * 0.5),
                child: Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: Colors.blue[400],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              SizedBox(height: spacing * 0.5),
              // Title
              Text(
                'Ride scheduled!',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
              SizedBox(height: spacing),
              // Divider
              Divider(color: Colors.grey[300], height: 1),
              SizedBox(height: spacing),
              // Scheduled Date and Time
              Text(
                _formatScheduledDate(scheduledDateTime),
                style: TextStyle(
                  fontSize: dateFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing * 0.75),
              // Instruction Message
              Text(
                'You can see scheduled rides in the activity menu.',
                style: TextStyle(
                  fontSize: messageFontSize,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing * 2),
              // Got It Button
              Builder(
                builder: (context) => SizedBox(
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
                      'Got It',
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
      ),
    );
  }
}

