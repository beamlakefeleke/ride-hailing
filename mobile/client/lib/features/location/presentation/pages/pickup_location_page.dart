import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/injections/injection_container.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';
import '../../../../features/rides/presentation/pages/ride_selection_page.dart';

class PickupLocationPage extends StatefulWidget {
  final Map<String, dynamic> destination;

  const PickupLocationPage({
    super.key,
    required this.destination,
  });

  @override
  State<PickupLocationPage> createState() => _PickupLocationPageState();
}

class _PickupLocationPageState extends State<PickupLocationPage> {
  Map<String, dynamic> _pickupLocation = {
    'name': 'Current Location',
    'address': 'Your current location',
    'latitude': 40.7295,
    'longitude': -73.9965,
  };
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Load saved addresses on init
    context.read<LocationBloc>().add(const GetSavedAddressesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
      context.read<LocationBloc>().add(SearchLocationsEvent(query: query));
    } else {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _onLocationSelected(Map<String, dynamic> location) {
    setState(() {
      _pickupLocation = location;
      _isSearching = false;
      _searchController.clear();
    });
  }

  void _onNext() {
    Navigator.of(context).pop();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RideSelectionPage(
        destination: widget.destination,
        pickupLocation: _pickupLocation,
      ),
    );
  }

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

    return BlocProvider(
      create: (context) => sl<LocationBloc>(),
      child: Container(
        height: size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
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
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search for pickup location',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[600]),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _isSearching = false;
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(spacing),
                    ),
                  ),
                ),
                SizedBox(height: spacing),
                // Selected Location Card or Search Results
                Expanded(
                  child: _isSearching
                      ? _buildSearchResults(
                          locationNameSize,
                          addressSize,
                          borderRadius,
                          spacing,
                          iconSize,
                        )
                      : _buildSelectedLocation(
                          locationNameSize,
                          addressSize,
                          borderRadius,
                          spacing,
                          iconSize,
                        ),
                ),
                SizedBox(height: spacing * 1.5),
                // Next Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onNext,
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
        ),
      ),
    );
  }

  Widget _buildSelectedLocation(
    double locationNameSize,
    double addressSize,
    double borderRadius,
    double spacing,
    double iconSize,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _pickupLocation['name'] as String? ?? 'Pickup Location',
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
                      _pickupLocation['address'] as String? ?? '',
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
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.grey[600],
                  size: iconSize * 0.8,
                ),
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(height: spacing),
        // Saved Addresses
        Text(
          'Saved Addresses',
          style: TextStyle(
            fontSize: locationNameSize,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: spacing * 0.5),
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

              if (state is SavedAddressesLoaded) {
                if (state.addresses.isEmpty) {
                  return Center(
                    child: Text(
                      'No saved addresses',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state.addresses.length,
                  itemBuilder: (context, index) {
                    final address = state.addresses[index];
                    return ListTile(
                      leading: Icon(
                        address.type == 'HOME'
                            ? Icons.home
                            : address.type == 'OFFICE'
                                ? Icons.work
                                : Icons.location_on,
                        color: const Color(0xFF4CAF50),
                      ),
                      title: Text(
                        address.name,
                        style: TextStyle(
                          fontSize: locationNameSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        address.address,
                        style: TextStyle(fontSize: addressSize),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        _onLocationSelected({
                          'name': address.name,
                          'address': address.address,
                          'latitude': address.latitude,
                          'longitude': address.longitude,
                        });
                      },
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(
    double locationNameSize,
    double addressSize,
    double borderRadius,
    double spacing,
    double iconSize,
  ) {
    return BlocBuilder<LocationBloc, LocationState>(
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

        if (state is LocationsLoaded) {
          if (state.locations.isEmpty) {
            return Center(
              child: Text(
                'No locations found',
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }

          return ListView.builder(
            itemCount: state.locations.length,
            itemBuilder: (context, index) {
              final location = state.locations[index];
              return ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: const Color(0xFF4CAF50),
                  size: iconSize,
                ),
                title: Text(
                  location.name,
                  style: TextStyle(
                    fontSize: locationNameSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  location.address,
                  style: TextStyle(fontSize: addressSize),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: location.distance != null
                    ? Text(
                        '${location.distance!.toStringAsFixed(1)} km',
                        style: TextStyle(
                          fontSize: addressSize,
                          color: Colors.grey[600],
                        ),
                      )
                    : null,
                onTap: () {
                  _onLocationSelected({
                    'name': location.name,
                    'address': location.address,
                    'latitude': location.latitude,
                    'longitude': location.longitude,
                  });
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}


