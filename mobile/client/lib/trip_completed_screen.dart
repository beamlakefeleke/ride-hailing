import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'features/ratings/presentation/pages/driver_rating_page.dart';

class TripCompletedScreen extends StatefulWidget {
  final Map<String, dynamic> destination;
  final Map<String, dynamic> pickupLocation;
  final Map<String, dynamic> selectedRide;
  final Map<String, dynamic>? selectedPayment;
  final Map<String, dynamic>? selectedPromo;
  final Map<String, dynamic> driver;

  const TripCompletedScreen({
    super.key,
    required this.destination,
    required this.pickupLocation,
    required this.selectedRide,
    this.selectedPayment,
    this.selectedPromo,
    required this.driver,
  });

  @override
  State<TripCompletedScreen> createState() => _TripCompletedScreenState();
}

class _TripCompletedScreenState extends State<TripCompletedScreen> {
  int _selectedMoodIndex = 3; // Default to happy emoji (4th one, index 3)

  // Trip statistics (in real app, these would come from the actual trip data)
  final Map<String, dynamic> _tripStats = {
    'duration': '3 mins',
    'distance': '1.1 km',
    'avgSpeed': '22 km/h',
  };

  // Default destination coordinates
  LatLng get _destinationLatLng {
    if (widget.destination['lat'] != null &&
        widget.destination['lng'] != null) {
      return LatLng(
        widget.destination['lat'] as double,
        widget.destination['lng'] as double,
      );
    }
    return const LatLng(40.7308, -73.9973); // Larchmont Hotel area
  }

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId('destination'),
        position: _destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: widget.destination['name'] ?? 'Destination',
        ),
      ),
    };
  }

  void _onFinish() {
    // Navigate to driver rating screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DriverRatingPage(
          driver: widget.driver,
          selectedRide: widget.selectedRide,
          selectedPayment: widget.selectedPayment,
          selectedPromo: widget.selectedPromo,
          rideId: widget.selectedRide['id'] as int?, // Pass ride ID if available
        ),
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
    final destinationNameSize = clampDouble(size.width * 0.048, 18, 22);
    final addressFontSize = clampDouble(size.width * 0.035, 12, 14);
    final statValueFontSize = clampDouble(size.width * 0.048, 18, 22);
    final statLabelFontSize = clampDouble(size.width * 0.032, 11, 13);
    final moodTitleFontSize = clampDouble(size.width * 0.038, 13, 15);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final cardPadding = clampDouble(size.width * 0.04, 12, 16);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final emojiSize = clampDouble(size.width * 0.1, 40, 56);

    return Scaffold(
      body: Stack(
        children: [
          // Blurred Map Background
          _buildBlurredMapBackground(),
          // Red Pin Overlay (centered, slightly overlapping the card)
          Positioned(
            top: size.height * 0.35,
            left: size.width / 2 - 15,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          // White Content Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildContentCard(
              size,
              clampDouble,
              horizontalPadding,
              titleFontSize,
              destinationNameSize,
              addressFontSize,
              statValueFontSize,
              statLabelFontSize,
              moodTitleFontSize,
              buttonFontSize,
              spacing,
              cardPadding,
              borderRadius,
              iconSize,
              emojiSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurredMapBackground() {
    return Stack(
      children: [
        // Map
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _destinationLatLng,
            zoom: 16.0,
          ),
          markers: _markers,
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

  Widget _buildContentCard(
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double titleFontSize,
    double destinationNameSize,
    double addressFontSize,
    double statValueFontSize,
    double statLabelFontSize,
    double moodTitleFontSize,
    double buttonFontSize,
    double spacing,
    double cardPadding,
    double borderRadius,
    double iconSize,
    double emojiSize,
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: spacing),
                // "You have arrived!" Title
                Center(
                  child: Text(
                    'You have arrived!',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                // Destination Details
                Text(
                  widget.destination['name'] ?? 'Larchmont Hotel',
                  style: TextStyle(
                    fontSize: destinationNameSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: spacing * 0.5),
                Text(
                  widget.destination['address'] ??
                      '27 W 11th St. New York, NY 10011, United States',
                  style: TextStyle(
                    fontSize: addressFontSize,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                // Trip Statistics
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.access_time,
                      value: _tripStats['duration']!,
                      label: 'Duration',
                      iconSize: iconSize,
                      valueFontSize: statValueFontSize,
                      labelFontSize: statLabelFontSize,
                    ),
                    _buildStatItem(
                      icon: Icons.location_on,
                      value: _tripStats['distance']!,
                      label: 'Distance',
                      iconSize: iconSize,
                      valueFontSize: statValueFontSize,
                      labelFontSize: statLabelFontSize,
                    ),
                    _buildStatItem(
                      icon: Icons.speed,
                      value: _tripStats['avgSpeed']!,
                      label: 'Avg. Speed',
                      iconSize: iconSize,
                      valueFontSize: statValueFontSize,
                      labelFontSize: statLabelFontSize,
                    ),
                  ],
                ),
                SizedBox(height: spacing * 2),
                // Mood Rating Section
                Text(
                  'How was your mood during this trip?',
                  style: TextStyle(
                    fontSize: moodTitleFontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: spacing),
                // Emoji Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMoodIndex = index;
                        });
                      },
                      child: Container(
                        width: emojiSize,
                        height: emojiSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedMoodIndex == index
                              ? const Color(0xFF4CAF50)
                              : Colors.transparent,
                          border: _selectedMoodIndex == index
                              ? Border.all(
                                  color: const Color(0xFF4CAF50),
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            _getEmoji(index),
                            style: TextStyle(
                              fontSize: emojiSize * 0.6,
                              color: _selectedMoodIndex == index
                                  ? null
                                  : Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: spacing * 2),
                // Finish Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onFinish,
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
                      'Finish',
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

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required double iconSize,
    required double valueFontSize,
    required double labelFontSize,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: Colors.grey[700],
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: valueFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _getEmoji(int index) {
    switch (index) {
      case 0:
        return '😢'; // Sad
      case 1:
        return '😐'; // Neutral
      case 2:
        return '🙂'; // Slightly happy
      case 3:
        return '😊'; // Happy (default selected)
      case 4:
        return '😄'; // Very happy
      default:
        return '😊';
    }
  }
}

