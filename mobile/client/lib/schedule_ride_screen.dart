import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScheduleRideScreen extends StatefulWidget {
  final Map<String, dynamic> destination;
  final Map<String, dynamic> pickupLocation;
  final Map<String, dynamic> selectedRide;

  const ScheduleRideScreen({
    super.key,
    required this.destination,
    required this.pickupLocation,
    required this.selectedRide,
  });

  @override
  State<ScheduleRideScreen> createState() => _ScheduleRideScreenState();
}

class _ScheduleRideScreenState extends State<ScheduleRideScreen> {
  int _selectedDateTab = 1; // 0: Today, 1: Tomorrow, 2: Select Date
  int _selectedHour = 4; // 4 PM (in 12-hour format)
  int _selectedMinute = 0;
  bool _isPM = true;
  DateTime? _customDate;

  final FixedExtentScrollController _hourController = FixedExtentScrollController();
  final FixedExtentScrollController _minuteController = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    // Set initial scroll position for hour and minute
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hourController.jumpToItem(_selectedHour - 1);
      _minuteController.jumpToItem(_selectedMinute);
    });
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  DateTime get _selectedDate {
    final now = DateTime.now();
    switch (_selectedDateTab) {
      case 0: // Today
        return DateTime(now.year, now.month, now.day);
      case 1: // Tomorrow
        return DateTime(now.year, now.month, now.day + 1);
      case 2: // Custom date
        return _customDate ?? DateTime(now.year, now.month, now.day + 1);
      default:
        return DateTime(now.year, now.month, now.day + 1);
    }
  }

  String _getDateTabLabel(int index) {
    switch (index) {
      case 0:
        return 'Today';
      case 1:
        return 'Tomorrow';
      case 2:
        return 'Select Date';
      default:
        return '';
    }
  }

  void _onSetSchedule() {
    final scheduledDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _isPM ? (_selectedHour == 12 ? 12 : _selectedHour + 12) : (_selectedHour == 12 ? 0 : _selectedHour),
      _selectedMinute,
    );

    // In real app, this would schedule the ride
    Navigator.of(context).pop({
      'scheduled': true,
      'dateTime': scheduledDateTime,
    });
  }

  Future<void> _selectCustomDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _customDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _customDate = picked;
        _selectedDateTab = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.048, 18, 22);
    final tabFontSize = clampDouble(size.width * 0.038, 13, 15);
    final timeFontSize = clampDouble(size.width * 0.055, 20, 28);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);

    // Default coordinates
    final pickupLatLng = widget.pickupLocation['lat'] != null &&
            widget.pickupLocation['lng'] != null
        ? LatLng(
            widget.pickupLocation['lat'] as double,
            widget.pickupLocation['lng'] as double,
          )
        : const LatLng(40.7295, -73.9965);

    final dropoffLatLng = widget.destination['lat'] != null &&
            widget.destination['lng'] != null
        ? LatLng(
            widget.destination['lat'] as double,
            widget.destination['lng'] as double,
          )
        : const LatLng(40.7308, -73.9973);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Blurred Map Background
          _buildBlurredMapBackground(pickupLatLng, dropoffLatLng),
          // Modal Dialog
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildModalDialog(
              size,
              clampDouble,
              horizontalPadding,
              titleFontSize,
              tabFontSize,
              timeFontSize,
              buttonFontSize,
              spacing,
              borderRadius,
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
                title: widget.pickupLocation['name'] ?? 'Pickup',
              ),
            ),
            Marker(
              markerId: const MarkerId('dropoff'),
              position: dropoff,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              infoWindow: InfoWindow(
                title: widget.destination['name'] ?? 'Destination',
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

  Widget _buildModalDialog(
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double titleFontSize,
    double tabFontSize,
    double timeFontSize,
    double buttonFontSize,
    double spacing,
    double borderRadius,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacing * 0.5),
              // Title
              Text(
                'Schedule a Ride',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
              SizedBox(height: spacing * 1.5),
              // Date Selection Tabs
              Row(
                children: List.generate(3, (index) {
                  final isSelected = _selectedDateTab == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (index == 2) {
                          _selectCustomDate();
                        } else {
                          setState(() {
                            _selectedDateTab = index;
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: clampDouble(size.width * 0.01, 2, 4),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: spacing * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF4CAF50)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF4CAF50)
                                : Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getDateTabLabel(index),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: tabFontSize,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF212121),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: spacing * 2),
              // Time Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hour Picker
                  Expanded(
                    child: _buildTimePicker(
                      controller: _hourController,
                      itemCount: 12,
                      selectedValue: _selectedHour,
                      onChanged: (value) {
                        setState(() {
                          _selectedHour = value + 1;
                        });
                      },
                      timeFontSize: timeFontSize,
                      spacing: spacing,
                    ),
                  ),
                  // Colon
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: clampDouble(size.width * 0.02, 4, 8),
                    ),
                    child: Text(
                      ':',
                      style: TextStyle(
                        fontSize: timeFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  // Minute Picker
                  Expanded(
                    child: _buildTimePicker(
                      controller: _minuteController,
                      itemCount: 60,
                      selectedValue: _selectedMinute,
                      onChanged: (value) {
                        setState(() {
                          _selectedMinute = value;
                        });
                      },
                      timeFontSize: timeFontSize,
                      spacing: spacing,
                    ),
                  ),
                  SizedBox(width: spacing * 0.5),
                  // AM/PM Toggle
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPM = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing * 0.5,
                            vertical: spacing * 0.25,
                          ),
                          decoration: BoxDecoration(
                            color: !_isPM
                                ? const Color(0xFF4CAF50)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'AM',
                            style: TextStyle(
                              fontSize: tabFontSize,
                              fontWeight: FontWeight.w600,
                              color: !_isPM
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: spacing * 0.25),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPM = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing * 0.5,
                            vertical: spacing * 0.25,
                          ),
                          decoration: BoxDecoration(
                            color: _isPM
                                ? const Color(0xFF4CAF50)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'PM',
                            style: TextStyle(
                              fontSize: tabFontSize,
                              fontWeight: FontWeight.w600,
                              color: _isPM
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: spacing * 2),
              // Action Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: clampDouble(size.height * 0.022, 16, 20),
                        ),
                        side: const BorderSide(
                          color: Color(0xFF4CAF50),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing),
                  // Set Schedule Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onSetSchedule,
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
                        'Set Schedule',
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

  Widget _buildTimePicker({
    required FixedExtentScrollController controller,
    required int itemCount,
    required int selectedValue,
    required Function(int) onChanged,
    required double timeFontSize,
    required double spacing,
  }) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 50,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final value = index;
            final isSelected = (itemCount == 12 && value + 1 == selectedValue) ||
                (itemCount == 60 && value == selectedValue);
            final displayValue = itemCount == 12 ? (value + 1).toString() : value.toString().padLeft(2, '0');

            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    displayValue,
                    style: TextStyle(
                      fontSize: isSelected ? timeFontSize : timeFontSize * 0.7,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? const Color(0xFF4CAF50)
                          : Colors.grey[600],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 30,
                      height: 2,
                      color: const Color(0xFF4CAF50),
                    ),
                ],
              ),
            );
          },
          childCount: itemCount,
        ),
      ),
    );
  }
}

