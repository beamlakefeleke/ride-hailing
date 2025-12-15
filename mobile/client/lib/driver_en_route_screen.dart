import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'driver_information_screen.dart';
import 'trip_completed_screen.dart';
import 'cancel_ride_reason_screen.dart';

class DriverEnRouteScreen extends StatefulWidget {
  final Map<String, dynamic> destination;
  final Map<String, dynamic> pickupLocation;
  final Map<String, dynamic> selectedRide;
  final Map<String, dynamic>? selectedPayment;
  final Map<String, dynamic>? selectedPromo;

  const DriverEnRouteScreen({
    super.key,
    required this.destination,
    required this.pickupLocation,
    required this.selectedRide,
    this.selectedPayment,
    this.selectedPromo,
  });

  @override
  State<DriverEnRouteScreen> createState() => _DriverEnRouteScreenState();
}

class _DriverEnRouteScreenState extends State<DriverEnRouteScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Driver data (in real app, this would come from API)
  final Map<String, dynamic> _driver = {
    'name': 'Theo Holland',
    'rating': 4.8,
    'phone': '+1 (646) 555-5640',
    'vehicle': 'Toyota Corolla',
    'vehicleColor': 'White',
    'licensePlate': 'NYC-3560',
    'eta': 1, // minutes
  };

  // Default to NYU area if coordinates not provided
  LatLng get _pickupLatLng {
    if (widget.pickupLocation['lat'] != null &&
        widget.pickupLocation['lng'] != null) {
      return LatLng(
        widget.pickupLocation['lat'] as double,
        widget.pickupLocation['lng'] as double,
      );
    }
    return const LatLng(40.7295, -73.9965); // Bobst Library / NYU
  }

  LatLng get _dropoffLatLng {
    if (widget.destination['lat'] != null &&
        widget.destination['lng'] != null) {
      return LatLng(
        widget.destination['lat'] as double,
        widget.destination['lng'] as double,
      );
    }
    return const LatLng(40.7308, -73.9973); // Larchmont Hotel area
  }

  // Driver location (slightly north of pickup for demo)
  LatLng get _driverLatLng {
    return LatLng(
      _pickupLatLng.latitude + 0.002,
      _pickupLatLng.longitude - 0.001,
    );
  }

  LatLng get _centerPosition {
    return LatLng(
      (_pickupLatLng.latitude + _driverLatLng.latitude) / 2,
      (_pickupLatLng.longitude + _driverLatLng.longitude) / 2,
    );
  }

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

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
      // Extract discount percentage from promo title (e.g., "20% OFF")
      final title = widget.selectedPromo!['title'] as String;
      final match = RegExp(r'(\d+)%').firstMatch(title);
      if (match != null) {
        final discountPercent = double.parse(match.group(1)!);
        return _tripFare * (discountPercent / 100);
      }
    }
    // Default 20% discount to match the image
    return _tripFare * 0.20;
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

  @override
  void initState() {
    super.initState();
    _createMarkers();
    _createRoute();

    // Pulse animation for user location indicator
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Navigate to trip completed screen after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => TripCompletedScreen(
              destination: widget.destination,
              pickupLocation: widget.pickupLocation,
              selectedRide: widget.selectedRide,
              selectedPayment: widget.selectedPayment,
              selectedPromo: widget.selectedPromo,
              driver: _driver,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _createMarkers() {
    _markers = {
      // Pickup location (green)
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: widget.pickupLocation['name'] ?? 'Pickup Location',
        ),
      ),
      // Dropoff location (red)
      Marker(
        markerId: const MarkerId('dropoff'),
        position: _dropoffLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: widget.destination['name'] ?? 'Destination',
        ),
      ),
      // Driver location (car icon - using default blue for now)
      Marker(
        markerId: const MarkerId('driver'),
        position: _driverLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(
          title: 'Driver: ${_driver['name']}',
        ),
      ),
    };
  }

  void _createRoute() {
    // Create a route polyline from driver to pickup location (solid green)
    final driverRoute = Polyline(
      polylineId: const PolylineId('driver_route'),
      points: [
        _driverLatLng,
        LatLng(
          _driverLatLng.latitude - 0.0005,
          _driverLatLng.longitude + 0.0003,
        ),
        LatLng(
          _pickupLatLng.latitude + 0.0002,
          _pickupLatLng.longitude - 0.0002,
        ),
        _pickupLatLng,
      ],
      color: const Color(0xFF4CAF50),
      width: 6,
      patterns: [],
    );

    // Create a dashed route polyline from pickup to dropoff
    final tripRoute = Polyline(
      polylineId: const PolylineId('trip_route'),
      points: [
        _pickupLatLng,
        LatLng(
          (_pickupLatLng.latitude + _dropoffLatLng.latitude) / 2,
          (_pickupLatLng.longitude + _dropoffLatLng.longitude) / 2,
        ),
        _dropoffLatLng,
      ],
      color: Colors.grey[600]!,
      width: 4,
      patterns: [PatternItem.dash(20), PatternItem.gap(10)],
    );

    _polylines = {driverRoute, tripRoute};
  }

  void _onCallDriver() {
    // Navigate to driver information screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DriverInformationScreen(driver: _driver),
      ),
    );
  }

  void _onMessageDriver() {
    // Navigate to driver information screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DriverInformationScreen(driver: _driver),
      ),
    );
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
          // Top Status Bar Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: _buildTopBar(size, clampDouble),
            ),
          ),
          // Pickup/Dropoff Info Card
          Positioned(
            top: clampDouble(size.height * 0.08, 60, 100),
            left: 0,
            right: 0,
            child: _buildLocationCard(size, clampDouble),
          ),
          // User Location Indicator with Pulsating Circles
          Positioned.fill(
            child: _buildUserLocationIndicator(size),
          ),
          // Map Control Buttons
          Positioned(
            bottom: clampDouble(size.height * 0.35, 200, 300),
            left: clampDouble(size.width * 0.05, 16, 24),
            child: _buildBackButton(clampDouble),
          ),
          Positioned(
            bottom: clampDouble(size.height * 0.35, 200, 300),
            right: clampDouble(size.width * 0.05, 16, 24),
            child: _buildLocationButton(clampDouble),
          ),
          // Bottom Driver Details Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildDriverPanel(size, clampDouble),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(Size size, Function clampDouble) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: clampDouble(size.width * 0.05, 16, 24),
        vertical: clampDouble(size.height * 0.01, 8, 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time
          Text(
            '9:41',
            style: TextStyle(
              fontSize: clampDouble(size.width * 0.04, 14, 16),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          // App Name/Logo
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: clampDouble(size.width * 0.06, 20, 28),
                height: clampDouble(size.width * 0.06, 20, 28),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              SizedBox(width: clampDouble(size.width * 0.02, 4, 8)),
              Text(
                'GoRide',
                style: TextStyle(
                  fontSize: clampDouble(size.width * 0.04, 14, 16),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          // Status Icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi,
                size: clampDouble(size.width * 0.05, 18, 22),
                color: Colors.black87,
              ),
              SizedBox(width: clampDouble(size.width * 0.02, 4, 8)),
              Icon(
                Icons.signal_cellular_4_bar,
                size: clampDouble(size.width * 0.05, 18, 22),
                color: Colors.black87,
              ),
              SizedBox(width: clampDouble(size.width * 0.02, 4, 8)),
              Icon(
                Icons.battery_full,
                size: clampDouble(size.width * 0.05, 18, 22),
                color: Colors.black87,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(Size size, Function clampDouble) {
    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.01, 8, 12);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      padding: EdgeInsets.all(horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pickup Location
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pickupLocation['name'] ?? 'Pickup Location',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: spacing * 0.25),
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.grey[300],
                      margin: EdgeInsets.only(left: spacing * 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing * 0.5),
          // Dropoff Location
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Text(
                  widget.destination['name'] ?? 'Destination',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserLocationIndicator(Size size) {
    return Center(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          final pulseValue = _pulseAnimation.value;
          final outerRadius = size.width * 0.15 * (0.5 + pulseValue * 0.5);
          final innerRadius = size.width * 0.12 * (0.7 + pulseValue * 0.3);
          final opacity = 1.0 - (pulseValue * 0.7);

          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulsating circle
              Container(
                width: outerRadius * 2,
                height: outerRadius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4CAF50).withOpacity(opacity * 0.2),
                ),
              ),
              // Middle pulsating circle
              Container(
                width: innerRadius * 2,
                height: innerRadius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4CAF50).withOpacity(opacity * 0.4),
                ),
              ),
              // User profile picture (center)
              Container(
                width: size.width * 0.12,
                height: size.width * 0.12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFF4CAF50),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Container(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF4CAF50),
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackButton(Function clampDouble) {
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
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildLocationButton(Function clampDouble) {
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
        icon: const Icon(Icons.my_location, color: Colors.black87),
        onPressed: () {
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(_pickupLatLng, 15.0),
          );
        },
      ),
    );
  }

  Widget _buildMapBackground() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _centerPosition,
        zoom: 15.0,
      ),
      markers: _markers,
      polylines: _polylines,
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

  Widget _buildDriverPanel(Size size, Function clampDouble) {
    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final subtitleFontSize = clampDouble(size.width * 0.038, 13, 15);
    final vehicleFontSize = clampDouble(size.width * 0.038, 13, 15);
    final driverNameSize = clampDouble(size.width * 0.042, 14, 16);
    final driverInfoSize = clampDouble(size.width * 0.035, 12, 14);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final buttonSize = clampDouble(size.width * 0.12, 48, 56);

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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: spacing * 0.5),
                // Status Message
                Text(
                  'Driver is heading to your location...',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: spacing * 0.5),
                // ETA
                Text(
                  'Driver will arriving in ${_driver['eta']} min...',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                SizedBox(height: spacing),
                // Vehicle Details
                Text(
                  '${_driver['vehicle']}, ${_driver['vehicleColor']} · ${_driver['licensePlate']}',
                  style: TextStyle(
                    fontSize: vehicleFontSize,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: spacing),
                // Ride Details Card
                _buildRideDetailsCard(size, clampDouble, spacing, titleFontSize),
                SizedBox(height: spacing),
                // Fare Breakdown Card
                _buildFareBreakdownCard(size, clampDouble, spacing, titleFontSize),
                SizedBox(height: spacing),
                // Driver Profile Section
                Row(
                  children: [
                    // Driver Profile Picture (Tappable)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DriverInformationScreen(driver: _driver),
                          ),
                        );
                      },
                      child: Container(
                        width: buttonSize,
                        height: buttonSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          border: Border.all(
                            color: const Color(0xFF4CAF50),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Container(
                            color: const Color(0xFF4CAF50).withOpacity(0.1),
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFF4CAF50),
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: spacing),
                    // Driver Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _driver['name'] as String,
                            style: TextStyle(
                              fontSize: driverNameSize,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF212121),
                            ),
                          ),
                          SizedBox(height: spacing * 0.25),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: driverInfoSize * 1.2,
                                color: Colors.amber,
                              ),
                              SizedBox(width: spacing * 0.25),
                              Text(
                                '${_driver['rating']}',
                                style: TextStyle(
                                  fontSize: driverInfoSize,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing * 0.25),
                          Text(
                            _driver['phone'] as String,
                            style: TextStyle(
                              fontSize: driverInfoSize,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Action Buttons
                    SizedBox(width: spacing * 0.5),
                    // Message Button
                    Container(
                      width: buttonSize,
                      height: buttonSize,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.message,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: _onMessageDriver,
                      ),
                    ),
                    SizedBox(width: spacing * 0.5),
                    // Call Button
                    Container(
                      width: buttonSize,
                      height: buttonSize,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: _onCallDriver,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing * 1.5),
                // Cancel Ride Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _onCancelRide,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: clampDouble(size.height * 0.02, 14, 18),
                      ),
                      side: const BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          clampDouble(size.width * 0.04, 12, 16),
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancel Ride',
                      style: TextStyle(
                        fontSize: clampDouble(size.width * 0.042, 14, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
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

  Widget _buildRideDetailsCard(
    Size size,
    Function clampDouble,
    double spacing,
    double fontSize,
  ) {
    final cardPadding = clampDouble(size.width * 0.04, 12, 16);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final detailFontSize = clampDouble(size.width * 0.038, 13, 15);

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
                  fontSize: detailFontSize,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                _rideName,
                style: TextStyle(
                  fontSize: detailFontSize,
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
                  fontSize: detailFontSize,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                _paymentMethod,
                style: TextStyle(
                  fontSize: detailFontSize,
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
    double spacing,
    double fontSize,
  ) {
    final cardPadding = clampDouble(size.width * 0.04, 12, 16);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final detailFontSize = clampDouble(size.width * 0.038, 13, 15);
    final totalFontSize = clampDouble(size.width * 0.042, 14, 16);

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
                  fontSize: detailFontSize,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '\$${_tripFare.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: detailFontSize,
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
                    fontSize: detailFontSize,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '- \$${_discountAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: detailFontSize,
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

  void _onCancelRide() {
    // Navigate to cancel ride reason screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CancelRideReasonScreen(),
      ),
    );
  }
}

