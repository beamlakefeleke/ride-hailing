import 'package:flutter/material.dart';
import 'pickup_location_screen.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key});

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  bool _isRecentSelected = true;
  final TextEditingController _destinationController = TextEditingController();

  final List<Map<String, dynamic>> _recentDestinations = [
    {
      'name': 'New York University',
      'address': 'New York, NY 10012, United Stat...',
      'distance': '0.4 km',
    },
    {
      'name': 'Washington Square Park',
      'address': 'Washington Square Park, New Y...',
      'distance': '0.5 km',
    },
    {
      'name': 'Comedy Cellar',
      'address': '117 Macdougal St, New York, NY...',
      'distance': '0.8 km',
    },
    {
      'name': 'Stand Book Store',
      'address': '828 Broadway, New York, NY 100...',
      'distance': '1.1 km',
    },
    {
      'name': 'Union Square Greenmar...',
      'address': 'Union Square Park, New York, NY...',
      'distance': '1.5 km',
    },
    {
      'name': 'Village Vanguard',
      'address': '178 7th Ave S, New York, NY 10014',
      'distance': '1.6 km',
    },
  ];

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
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

    return Container(
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
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                itemCount: _recentDestinations.length,
                itemBuilder: (context, index) {
                  final destination = _recentDestinations[index];
                  return _buildDestinationItem(
                    destination,
                    listItemTitleSize,
                    listItemSubtitleSize,
                    iconSize,
                    spacing,
                  );
                },
              ),
            ),
          ],
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
       onTap: () async {
         // Dismiss current modal first
         Navigator.of(context).pop();
         // Show pickup location modal
         await showModalBottomSheet(
           context: context,
           isScrollControlled: true,
           backgroundColor: Colors.transparent,
           builder: (context) => PickupLocationScreen(destination: destination),
         );
       },
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
                    destination['name'] as String,
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
                          destination['address'] as String,
                          style: TextStyle(
                            fontSize: subtitleSize,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: spacing * 0.5),
                      Text(
                        destination['distance'] as String,
                        style: TextStyle(
                          fontSize: subtitleSize,
                          color: Colors.grey[600],
                        ),
                      ),
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

