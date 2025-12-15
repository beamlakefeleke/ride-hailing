import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../config/injections/injection_container.dart';
import '../bloc/ride_bloc.dart';
import '../bloc/ride_event.dart';
import '../bloc/ride_state.dart';
import '../../../../driver_en_route_screen.dart';

class DriverSearchPage extends StatefulWidget {
  final int rideId;
  final Map<String, dynamic> destination;
  final Map<String, dynamic> pickupLocation;
  final Map<String, dynamic> selectedRide;

  const DriverSearchPage({
    super.key,
    required this.rideId,
    required this.destination,
    required this.pickupLocation,
    required this.selectedRide,
  });

  @override
  State<DriverSearchPage> createState() => _DriverSearchPageState();
}

class _DriverSearchPageState extends State<DriverSearchPage>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  late AnimationController _pulseController;
  late AnimationController _searchController;
  late Animation<double> _pulseAnimation;
  Timer? _pollingTimer;

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

  LatLng get _centerPosition {
    return LatLng(
      (_pickupLatLng.latitude + _dropoffLatLng.latitude) / 2,
      (_pickupLatLng.longitude + _dropoffLatLng.longitude) / 2,
    );
  }

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();

    // Pulse animation for search indicator
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

    // Search animation (subtle movement)
    _searchController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Start polling for ride status
    _startPolling();
  }

  void _startPolling() {
    // Poll every 3 seconds for ride status
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      context.read<RideBloc>().add(GetRideEvent(rideId: widget.rideId));
    });

    // Initial fetch
    context.read<RideBloc>().add(GetRideEvent(rideId: widget.rideId));
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _pulseController.dispose();
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _createMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: widget.pickupLocation['name'] ?? 'Pickup Location',
        ),
      ),
      Marker(
        markerId: const MarkerId('dropoff'),
        position: _dropoffLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: widget.destination['name'] ?? 'Destination',
        ),
      ),
    };
  }

  void _onCancelRide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Ride'),
        content: const Text('Are you sure you want to cancel this ride?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              context.read<RideBloc>().add(
                    CancelRideEvent(rideId: widget.rideId),
                  );
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    return BlocProvider(
      create: (context) => sl<RideBloc>(),
      child: BlocConsumer<RideBloc, RideState>(
        listener: (context, state) {
          if (state is RideLoaded) {
            final ride = state.ride;
            // Check if driver is assigned and navigate accordingly
            if (ride.driverId != null &&
                (ride.status == 'DRIVER_ASSIGNED' ||
                    ride.status == 'DRIVER_EN_ROUTE')) {
              _pollingTimer?.cancel();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => DriverEnRouteScreen(
                    destination: widget.destination,
                    pickupLocation: widget.pickupLocation,
                    selectedRide: widget.selectedRide,
                    selectedPayment: null,
                    selectedPromo: null,
                  ),
                ),
              );
            }
          } else if (state is RideCancelled) {
            _pollingTimer?.cancel();
            Navigator.of(context).pop(); // Go back to previous screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ride cancelled successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is RideError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
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
                // Bottom Status Panel
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildStatusPanel(size, clampDouble, state),
                ),
              ],
            ),
          );
        },
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
          // Time (placeholder - in real app, get from system)
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
                'OurRide',
                style: TextStyle(
                  fontSize: clampDouble(size.width * 0.04, 14, 16),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          // Status Icons (WiFi, Battery, etc.)
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

  Widget _buildStatusPanel(Size size, Function clampDouble, RideState state) {
    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final subtitleFontSize = clampDouble(size.width * 0.038, 13, 15);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);

    String statusMessage = 'Finding you a nearby driver...';
    String statusSubtitle =
        'The driver will pick you up as soon as possible after they confirm your order.';

    if (state is RideLoaded) {
      final ride = state.ride;
      if (ride.driverId != null) {
        statusMessage = 'Driver assigned!';
        statusSubtitle = 'Your driver is on the way.';
      }
    }

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
            children: [
              SizedBox(height: spacing * 0.5),
              // Title
              Text(
                statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
              SizedBox(height: spacing * 0.5),
              // Subtitle
              Text(
                statusSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              SizedBox(height: spacing),
              // Pulsating Loading Indicator
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF4CAF50).withOpacity(
                        0.2 + (_pulseAnimation.value * 0.3),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF4CAF50).withOpacity(
                            0.4 + (_pulseAnimation.value * 0.4),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.search,
                            color: Color(0xFF4CAF50),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
                      fontSize: buttonFontSize,
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
    );
  }
}

