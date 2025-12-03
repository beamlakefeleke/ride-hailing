import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'destination_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedBottomNavIndex = 0;
  String? _selectedQuickDestination;
  GoogleMapController? _mapController;
  
  // New York University location
  static const LatLng _initialPosition = LatLng(40.7295, -73.9965);
  
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    _markers.addAll([
       Marker(
        markerId: MarkerId('user_location'),
        position: LatLng(40.7295, -73.9965),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Your Location'),
      ),
       Marker(
        markerId: MarkerId('poi_washington_square'),
        position: LatLng(40.7308, -73.9973),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: 'Washington Square Park'),
      ),
       Marker(
        markerId: MarkerId('poi_nyu'),
        position: LatLng(40.7295, -73.9965),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(title: 'New York University'),
      ),
    ]);
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
    });
  }

  void _onQuickDestinationTapped(String destination) {
    setState(() {
      _selectedQuickDestination = destination;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    return Scaffold(
      body: Stack(
        children: [
          // Map Background
          _buildMapBackground(),
          // Top Promotional Banner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: _buildPromoBanner(size, clampDouble),
            ),
          ),
          // Main Content Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildContentOverlay(size, clampDouble),
          ),
          // Map Control Button (Compass/Target)
          Positioned(
            bottom: clampDouble(size.height * 0.35, 200, 300),
            right: clampDouble(size.width * 0.05, 16, 24),
            child: _buildMapControlButton(clampDouble),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(size, clampDouble),
    );
  }

  Widget _buildPromoBanner(Size size, Function clampDouble) {
    final fontSize = clampDouble(size.width * 0.035, 12, 14);
    final padding = clampDouble(size.width * 0.04, 12, 16);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding * 0.5,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding * 0.75,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Save 50% Off Additional Pairs',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
          Icon(
            Icons.close,
            size: fontSize * 1.2,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildMapBackground() {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: _initialPosition,
        zoom: 15.0,
      ),
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
    );
  }

  double clampDouble(double value, double min, double max) =>
      value.clamp(min, max).toDouble();


  Widget _buildMapControlButton(Function clampDouble) {
    final size = MediaQuery.of(context).size;
    final buttonSize = clampDouble(size.width * 0.12, 48, 56);

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          Icons.my_location,
          color: Colors.black87,
          size: buttonSize * 0.5,
        ),
        onPressed: () {
          // Handle map recenter
        },
      ),
    );
  }

  Widget _buildContentOverlay(Size size, Function clampDouble) {
    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.07, 24, 32);
    final inputFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonFontSize = clampDouble(size.width * 0.038, 13, 15);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);

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
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacing * 0.5),
              // "Where to?" Heading
              Text(
                'Where to?',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
              SizedBox(height: spacing),
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: InkWell(
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const DestinationScreen(),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: spacing * 0.75,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: const Color(0xFF4CAF50),
                          size: clampDouble(size.width * 0.06, 22, 28),
                        ),
                        SizedBox(width: spacing * 0.5),
            Text(
                          'Enter location',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: inputFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing),
              // Quick Destination Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildQuickDestinationButton(
                      'Home',
                      _selectedQuickDestination == 'Home',
                      buttonFontSize,
                      borderRadius,
                      spacing,
                    ),
                    SizedBox(width: spacing * 0.5),
                    _buildQuickDestinationButton(
                      'Office',
                      _selectedQuickDestination == 'Office',
                      buttonFontSize,
                      borderRadius,
                      spacing,
                    ),
                    SizedBox(width: spacing * 0.5),
                    _buildQuickDestinationButton(
                      'Apartment',
                      _selectedQuickDestination == 'Apartment',
                      buttonFontSize,
                      borderRadius,
                      spacing,
                    ),
                    SizedBox(width: spacing * 0.5),
                    _buildQuickDestinationButton(
                      'Mom\'s H',
                      _selectedQuickDestination == 'Mom\'s H',
                      buttonFontSize,
                      borderRadius,
                      spacing,
            ),
          ],
        ),
      ),
              SizedBox(height: spacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickDestinationButton(
    String label,
    bool isSelected,
    double fontSize,
    double borderRadius,
    double spacing,
  ) {
    return GestureDetector(
      onTap: () => _onQuickDestinationTapped(label),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing,
          vertical: spacing * 0.6,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4CAF50)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(borderRadius * 2),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4CAF50)
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : const Color(0xFF212121),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(Size size, Function clampDouble) {
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final fontSize = clampDouble(size.width * 0.032, 11, 13);

    return Container(
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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: clampDouble(size.height * 0.01, 8, 12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem('Home', Icons.home, 0, iconSize, fontSize),
              _buildBottomNavItem('Promos', Icons.local_offer, 1, iconSize, fontSize),
              _buildBottomNavItem('Activity', Icons.receipt_long, 2, iconSize, fontSize),
              _buildBottomNavItem('Account', Icons.person, 3, iconSize, fontSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
    String label,
    IconData icon,
    int index,
    double iconSize,
    double fontSize,
  ) {
    final isSelected = _selectedBottomNavIndex == index;

    return GestureDetector(
      onTap: () => _onBottomNavTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: isSelected
                ? const Color(0xFF4CAF50)
                : Colors.grey[600],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
