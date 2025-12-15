import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/injections/injection_container.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';
import '../../domain/entities/saved_address.dart';

class SavedAddressesPage extends StatelessWidget {
  const SavedAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocationBloc>()..add(const GetSavedAddressesEvent()),
      child: const _SavedAddressesPageView(),
    );
  }
}

class _SavedAddressesPageView extends StatelessWidget {
  const _SavedAddressesPageView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final addressTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final addressSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context, size, clampDouble, titleFontSize),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AddressDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Address deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
            // Refresh the list
            context.read<LocationBloc>().add(const GetSavedAddressesEvent());
          }
        },
        builder: (context, state) {
          if (state is LocationLoading || state is LocationInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SavedAddressesLoaded) {
            final addresses = state.addresses;

            return Column(
              children: [
                Expanded(
                  child: addresses.isEmpty
                      ? Center(
                          child: Text(
                            'No saved addresses',
                            style: TextStyle(
                              fontSize: addressTitleFontSize,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(horizontalPadding),
                          itemCount: addresses.length,
                          itemBuilder: (context, index) {
                            final address = addresses[index];
                            return _buildAddressCard(
                              size,
                              clampDouble,
                              address,
                              addressTitleFontSize,
                              addressSubtitleFontSize,
                              spacing,
                              borderRadius,
                              context,
                            );
                          },
                        ),
                ),
                // Add Address Button
                Padding(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to add address screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Add address feature coming soon'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: EdgeInsets.symmetric(
                          vertical: spacing * 0.75,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                      ),
                      child: Text(
                        'Add Address',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          if (state is LocationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LocationBloc>().add(const GetSavedAddressesEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    Size size,
    Function clampDouble,
    double titleFontSize,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Saved Addresses',
        style: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF212121),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildAddressCard(
    Size size,
    Function clampDouble,
    SavedAddress address,
    double titleFontSize,
    double subtitleFontSize,
    double spacing,
    double borderRadius,
    BuildContext context,
  ) {
    IconData addressIcon;
    Color iconColor;

    switch (address.type) {
      case 'HOME':
        addressIcon = Icons.home;
        iconColor = Colors.blue;
        break;
      case 'OFFICE':
        addressIcon = Icons.work;
        iconColor = Colors.orange;
        break;
      case 'APARTMENT':
        addressIcon = Icons.apartment;
        iconColor = Colors.purple;
        break;
      default:
        addressIcon = Icons.location_on;
        iconColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.only(bottom: spacing),
      padding: EdgeInsets.all(clampDouble(size.width * 0.04, 12, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: clampDouble(size.width * 0.12, 40, 50),
            height: clampDouble(size.width * 0.12, 40, 50),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(borderRadius * 0.75),
            ),
            child: Icon(
              addressIcon,
              color: iconColor,
              size: 24,
            ),
          ),
          SizedBox(width: spacing),
          // Address Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.name,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: spacing * 0.25),
                Text(
                  address.address,
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Menu Button
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF212121)),
            onPressed: () {
              _showAddressMenu(context, address);
            },
          ),
        ],
      ),
    );
  }

  void _showAddressMenu(BuildContext context, SavedAddress address) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit address feature coming soon'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _showDeleteDialog(context, address);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, SavedAddress address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Are you sure you want to delete "${address.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<LocationBloc>().add(
                    DeleteSavedAddressEvent(addressId: address.id),
                  );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

