import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/injections/injection_container.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';
import 'pickup_location_page.dart';

class DestinationPage extends StatefulWidget {
  const DestinationPage({super.key});

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  bool _isRecentSelected = true;
  final TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load recent destinations on init
    context.read<LocationBloc>().add(const GetRecentDestinationsEvent());
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      context.read<LocationBloc>().add(SearchLocationsEvent(query: query));
    }
  }

  void _onLocationSelected(Map<String, dynamic> location) {
    Navigator.of(context).pop();
    // Show pickup location modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PickupLocationPage(destination: location),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 26);
    final inputFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonFontSize = clampDouble(size.width * 0.038, 13, 15);
    final listItemTitleSize = clampDouble(size.width * 0.042, 14, 16);
    final listItemSubtitleSize = clampDouble(size.width * 0.035, 12, 14);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);

    return BlocProvider(
      create: (context) => sl<LocationBloc>(),
      child: Container(
        height: size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: EdgeInsets.only(top: spacing * 0.5, bottom: spacing * 0.5),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black87),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Where do you want to go?',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: iconSize), // Balance the close button
                  ],
                ),
              ),
              // Input Area
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Current Location Row
                      InkWell(
                        onTap: () {
                          // Handle current location selection
                        },
                        child: Padding(
                          padding: EdgeInsets.all(spacing),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: const Color(0xFF4CAF50),
                                size: iconSize,
                              ),
                              SizedBox(width: spacing * 0.75),
                              Text(
                                'Your current location',
                                style: TextStyle(
                                  fontSize: inputFontSize,
                                  color: const Color(0xFF212121),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey[300]),
                      // Destination Input Row
                      Padding(
                        padding: EdgeInsets.all(spacing),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red[400],
                              size: iconSize,
                            ),
                            SizedBox(width: spacing * 0.75),
                            Expanded(
                              child: TextField(
                                controller: _destinationController,
                                autofocus: true,
                                onChanged: _onSearchChanged,
                                style: TextStyle(
                                  fontSize: inputFontSize,
                                  color: const Color(0xFF212121),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Where to?',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: inputFontSize,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            SizedBox(width: spacing * 0.5),
                            Container(
                              width: iconSize * 1.2,
                              height: iconSize * 1.2,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  // Handle add stop
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing),
              // Quick Action Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildQuickActionButton(
                        'Select from map',
                        Icons.map,
                        buttonFontSize,
                        borderRadius,
                        spacing,
                      ),
                      SizedBox(width: spacing * 0.5),
                      _buildQuickActionButton(
                        'Home',
                        null,
                        buttonFontSize,
                        borderRadius,
                        spacing,
                      ),
                      SizedBox(width: spacing * 0.5),
                      _buildQuickActionButton(
                        'Office',
                        null,
                        buttonFontSize,
                        borderRadius,
                        spacing,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing * 1.5),
              // Tabs
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTab('Recent', buttonFontSize, spacing),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: _buildTab('Suggested', buttonFontSize, spacing),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing),
              // Destination List
              Expanded(
                child: BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, state) {
                    if (state is LocationLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is LocationError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    List<Map<String, dynamic>> locations = [];

                    if (_isRecentSelected) {
                      if (state is RecentDestinationsLoaded) {
                        locations = state.destinations.map((location) {
                          return {
                            'name': location.name,
                            'address': location.address,
                            'latitude': location.latitude,
                            'longitude': location.longitude,
                            'distance': location.distance != null
                                ? '${location.distance!.toStringAsFixed(1)} km'
                                : null,
                          };
                        }).toList();
                      }
                    } else {
                      if (state is LocationsLoaded) {
                        locations = state.locations.map((location) {
                          return {
                            'name': location.name,
                            'address': location.address,
                            'latitude': location.latitude,
                            'longitude': location.longitude,
                            'distance': location.distance != null
                                ? '${location.distance!.toStringAsFixed(1)} km'
                                : null,
                          };
                        }).toList();
                      }
                    }

                    if (locations.isEmpty) {
                      return Center(
                        child: Text(
                          _isRecentSelected
                              ? 'No recent destinations'
                              : 'No locations found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: inputFontSize,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        final destination = locations[index];
                        return _buildDestinationItem(
                          destination,
                          listItemTitleSize,
                          listItemSubtitleSize,
                          iconSize,
                          spacing,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData? icon,
    double fontSize,
    double borderRadius,
    double spacing,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing,
        vertical: spacing * 0.6,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(borderRadius * 2),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: const Color(0xFF4CAF50),
              size: fontSize * 1.2,
            ),
            SizedBox(width: spacing * 0.5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, double fontSize, double spacing) {
    final isSelected = _isRecentSelected == (label == 'Recent');
    return GestureDetector(
      onTap: () {
        setState(() {
          _isRecentSelected = label == 'Recent';
        });
        if (_isRecentSelected) {
          context.read<LocationBloc>().add(const GetRecentDestinationsEvent());
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? const Color(0xFF4CAF50)
                : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationItem(
    Map<String, dynamic> destination,
    double titleSize,
    double subtitleSize,
    double iconSize,
    double spacing,
  ) {
    return InkWell(
      onTap: () => _onLocationSelected(destination),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
        child: Row(
          children: [
            // Location Icon
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black87,
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.location_on,
                size: iconSize * 0.6,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: spacing),
            // Destination Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination['name'] as String? ?? '',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: spacing * 0.25),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          destination['address'] as String? ?? '',
                          style: TextStyle(
                            fontSize: subtitleSize,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (destination['distance'] != null) ...[
                        SizedBox(width: spacing * 0.5),
                        Text(
                          destination['distance'] as String,
                          style: TextStyle(
                            fontSize: subtitleSize,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: spacing * 0.5),
            // Bookmark Icon
            IconButton(
              icon: Icon(
                Icons.bookmark_border,
                color: Colors.grey[600],
                size: iconSize * 0.8,
              ),
              onPressed: () {
                // Handle bookmark
              },
            ),
          ],
        ),
      ),
    );
  }
}

