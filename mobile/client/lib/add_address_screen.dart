import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressScreen extends StatefulWidget {
  final Map<String, dynamic>? existingAddress;

  const AddAddressScreen({
    Key? key,
    this.existingAddress,
  }) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressDetailsController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;

  // Default location: The Bleecker (100 Bleecker St, New York, NY 10012)
  static const LatLng _defaultLocation = LatLng(40.7282, -73.9942);
  LatLng _selectedLocation = _defaultLocation;

  String _selectedAddressName = 'The Bleecker';
  String _selectedAddress = '100 Bleecker St, New York, NY 10012, United States';

  @override
  void initState() {
    super.initState();
    if (widget.existingAddress != null) {
      _nameController.text = widget.existingAddress!['name'] as String;
      _selectedAddress = widget.existingAddress!['address'] as String;
      _selectedAddressName = widget.existingAddress!['name'] as String;
    } else {
      _nameController.text = 'Mom\'s House';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressDetailsController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSaveAddress() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a name for this address'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Save address logic here
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Address "${_nameController.text}" saved'),
        duration: const Duration(seconds: 2),
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
    final labelFontSize = clampDouble(size.width * 0.038, 13, 15);
    final inputFontSize = clampDouble(size.width * 0.038, 13, 15);
    final addressTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final addressSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);

    return Scaffold(
      body: Column(
        children: [
          // Map Section
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                // Google Map
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: 16,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('selected_location'),
                      position: _selectedLocation,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                  },
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
                // Search Bar
                Positioned(
                  top: MediaQuery.of(context).padding.top + spacing,
                  left: horizontalPadding,
                  right: horizontalPadding,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing,
                      vertical: spacing * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        SizedBox(width: spacing * 0.5),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search for a location',
                              hintStyle: TextStyle(
                                fontSize: inputFontSize,
                                color: Colors.grey[400],
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            style: TextStyle(fontSize: inputFontSize),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Back Button
                Positioned(
                  bottom: spacing,
                  left: horizontalPadding,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                // Location Button
                Positioned(
                  bottom: spacing,
                  right: horizontalPadding,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.my_location, size: 20),
                      onPressed: () {
                        // Center map on user location
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLng(_selectedLocation),
                        );
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Form Section
          Container(
            padding: EdgeInsets.all(horizontalPadding),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: spacing),
                // Title
                Center(
                  child: Text(
                    'Add an Address',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                // Selected Address Card
                Container(
                  padding: EdgeInsets.all(clampDouble(size.width * 0.04, 12, 16)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 24,
                      ),
                      SizedBox(width: spacing * 0.75),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedAddressName,
                              style: TextStyle(
                                fontSize: addressTitleFontSize,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF212121),
                              ),
                            ),
                            SizedBox(height: spacing * 0.25),
                            Text(
                              _selectedAddress,
                              style: TextStyle(
                                fontSize: addressSubtitleFontSize,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                // Name Input
                Text(
                  'Name',
                  style: TextStyle(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: spacing * 0.5),
                TextField(
                  controller: _nameController,
                  style: TextStyle(fontSize: inputFontSize),
                  decoration: InputDecoration(
                    hintText: 'Enter address name',
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: const BorderSide(
                        color: Color(0xFF4CAF50),
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(spacing),
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                // Address Details Input
                Text(
                  'Address Details',
                  style: TextStyle(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: spacing * 0.5),
                TextField(
                  controller: _addressDetailsController,
                  style: TextStyle(fontSize: inputFontSize),
                  decoration: InputDecoration(
                    hintText: 'e.g. Floor, unit number',
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: const BorderSide(
                        color: Color(0xFF4CAF50),
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(spacing),
                  ),
                ),
                SizedBox(height: spacing * 2),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: clampDouble(size.height * 0.02, 14, 18),
                          ),
                          side: BorderSide(
                            color: Colors.green[300]!,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onSaveAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          padding: EdgeInsets.symmetric(
                            vertical: clampDouble(size.height * 0.02, 14, 18),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Save Address',
                          style: TextStyle(
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
        ],
      ),
    );
  }
}

