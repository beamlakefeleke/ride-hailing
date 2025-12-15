import 'package:flutter/material.dart';
import 'dart:ui';
import 'add_address_screen.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final List<Map<String, dynamic>> _savedAddresses = [
    {
      'name': 'Home',
      'address': '85 4th Ave, New York, NY 10003, United States',
      'id': '1',
    },
    {
      'name': 'Office',
      'address': '303 Mercer St, New York, NY 10003, United States',
      'id': '2',
    },
    {
      'name': 'Apartment',
      'address': '69 E 9th St, New York, NY 10003, United States',
      'id': '3',
    },
    {
      'name': 'Mom\'s House',
      'address': '100 Bleecker St, New York, NY 10012, United States',
      'id': '4',
    },
  ];

  void _showDeleteDialog(int index) {
    final address = _savedAddresses[index];
    showDialog(
      context: context,
      builder: (context) => DeleteAddressDialog(
        addressName: address['name'] as String,
        address: address['address'] as String,
        onDelete: () {
          setState(() {
            _savedAddresses.removeAt(index);
          });
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Address deleted'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _showAddressMenu(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
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
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('Edit'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddAddressScreen(
                        existingAddress: _savedAddresses[index],
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _showDeleteDialog(index);
                },
              ),
            ],
          ),
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
    final addressTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final addressSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context, size, clampDouble, titleFontSize),
      body: Column(
        children: [
          Expanded(
            child: _savedAddresses.isEmpty
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
                    itemCount: _savedAddresses.length,
                    itemBuilder: (context, index) {
                      final address = _savedAddresses[index];
                      return _buildAddressCard(
                        size,
                        clampDouble,
                        address,
                        addressTitleFontSize,
                        addressSubtitleFontSize,
                        spacing,
                        borderRadius,
                        index,
                      );
                    },
                  ),
          ),
          // Add Address Button
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
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddAddressScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    'Add Address',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
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
                ),
              ),
            ),
          ),
        ],
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
    Map<String, dynamic> address,
    double titleFontSize,
    double subtitleFontSize,
    double spacing,
    double borderRadius,
    int index,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: spacing),
      padding: EdgeInsets.all(clampDouble(size.width * 0.05, 16, 24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Icon
          Container(
            width: clampDouble(size.width * 0.1, 36, 44),
            height: clampDouble(size.width * 0.1, 36, 44),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on,
              color: Color(0xFF4CAF50),
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
                  address['name'] as String,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: spacing * 0.25),
                Text(
                  address['address'] as String,
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: spacing * 0.5),
          // Action Icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.share, color: Colors.grey[600], size: 20),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sharing ${address['name']}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.grey[600], size: 20),
                onPressed: () => _showAddressMenu(context, index),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DeleteAddressDialog extends StatelessWidget {
  final String addressName;
  final String address;
  final VoidCallback onDelete;

  const DeleteAddressDialog({
    Key? key,
    required this.addressName,
    required this.address,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final messageFontSize = clampDouble(size.width * 0.038, 13, 15);
    final addressTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final addressSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius * 2),
        ),
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding * 1.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Delete Address',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: spacing),
              // Question
              Text(
                'Sure you want to delete this address?',
                style: TextStyle(
                  fontSize: messageFontSize,
                  color: const Color(0xFF212121),
                ),
              ),
              SizedBox(height: spacing * 1.5),
              // Address Card
              Container(
                padding: EdgeInsets.all(clampDouble(size.width * 0.04, 12, 16)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: clampDouble(size.width * 0.08, 28, 32),
                      height: clampDouble(size.width * 0.08, 28, 32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Color(0xFF4CAF50),
                        size: 18,
                      ),
                    ),
                    SizedBox(width: spacing * 0.75),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            addressName,
                            style: TextStyle(
                              fontSize: addressTitleFontSize,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF212121),
                            ),
                          ),
                          SizedBox(height: spacing * 0.25),
                          Text(
                            address,
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
                      onPressed: () {
                        onDelete();
                      },
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
                        'Yes, Delete',
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
      ),
    );
  }
}

