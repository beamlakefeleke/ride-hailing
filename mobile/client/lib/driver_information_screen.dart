import 'package:flutter/material.dart';
import 'driver_chat_screen.dart';
import 'driver_voice_call_screen.dart';

class DriverInformationScreen extends StatelessWidget {
  final Map<String, dynamic> driver;

  const DriverInformationScreen({
    super.key,
    required this.driver,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final nameFontSize = clampDouble(size.width * 0.06, 22, 28);
    final phoneFontSize = clampDouble(size.width * 0.038, 13, 15);
    final statValueFontSize = clampDouble(size.width * 0.055, 20, 24);
    final statLabelFontSize = clampDouble(size.width * 0.035, 12, 14);
    final detailLabelFontSize = clampDouble(size.width * 0.038, 13, 15);
    final detailValueFontSize = clampDouble(size.width * 0.038, 13, 15);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final cardPadding = clampDouble(size.width * 0.04, 12, 16);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final profileSize = clampDouble(size.width * 0.25, 100, 140);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(size, clampDouble, titleFontSize, horizontalPadding),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: spacing),
            // Driver Profile Card
            _buildProfileCard(
              size,
              clampDouble,
              profileSize,
              nameFontSize,
              phoneFontSize,
              spacing,
              cardPadding,
              borderRadius,
              iconSize,
            ),
            SizedBox(height: spacing),
            // Driver Statistics Card
            _buildStatisticsCard(
              size,
              clampDouble,
              statValueFontSize,
              statLabelFontSize,
              spacing,
              cardPadding,
              borderRadius,
              iconSize,
            ),
            SizedBox(height: spacing),
            // Driver Details Card
            _buildDetailsCard(
              size,
              clampDouble,
              detailLabelFontSize,
              detailValueFontSize,
              spacing,
              cardPadding,
              borderRadius,
            ),
            SizedBox(height: spacing * 2),
            // Action Buttons
            _buildActionButtons(
              size,
              clampDouble,
              buttonFontSize,
              spacing,
              horizontalPadding,
              borderRadius,
            ),
            SizedBox(height: spacing),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    Size size,
    Function clampDouble,
    double titleFontSize,
    double horizontalPadding,
  ) {
    return AppBar(
      backgroundColor: const Color(0xFF81C784), // Light blue/green
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        'Driver Information',
        style: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProfileCard(
    Size size,
    Function clampDouble,
    double profileSize,
    double nameFontSize,
    double phoneFontSize,
    double spacing,
    double cardPadding,
    double borderRadius,
    double iconSize,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: clampDouble(size.width * 0.05, 16, 24)),
      padding: EdgeInsets.all(cardPadding * 1.5),
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
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: profileSize,
            height: profileSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple[100],
              border: Border.all(
                color: Colors.purple[200]!,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: Container(
                color: Colors.purple[100],
                child: const Icon(
                  Icons.person,
                  color: Colors.purple,
                  size: 60,
                ),
              ),
            ),
          ),
          SizedBox(height: spacing),
          // Driver Name
          Text(
            driver['name'] ?? 'Theo Holland',
            style: TextStyle(
              fontSize: nameFontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
          ),
          SizedBox(height: spacing * 0.5),
          // Phone Number with Copy Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                driver['phone'] ?? '+1 (646) 555-5640',
                style: TextStyle(
                  fontSize: phoneFontSize,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: spacing * 0.5),
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    // Copy phone number to clipboard
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Phone number copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.copy,
                    size: iconSize * 0.5,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(
    Size size,
    Function clampDouble,
    double statValueFontSize,
    double statLabelFontSize,
    double spacing,
    double cardPadding,
    double borderRadius,
    double iconSize,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: clampDouble(size.width * 0.05, 16, 24)),
      padding: EdgeInsets.all(cardPadding),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Rating
          _buildStatItem(
            icon: Icons.star_outline,
            value: driver['rating']?.toString() ?? '4.8',
            label: 'Rating',
            iconSize: iconSize,
            valueFontSize: statValueFontSize,
            labelFontSize: statLabelFontSize,
          ),
          // Divider
          Container(
            width: 1,
            height: 60,
            color: Colors.grey[300],
          ),
          // Ride Orders
          _buildStatItem(
            icon: Icons.directions_car_outlined,
            value: '9,205',
            label: 'Ride orders',
            iconSize: iconSize,
            valueFontSize: statValueFontSize,
            labelFontSize: statLabelFontSize,
          ),
          // Divider
          Container(
            width: 1,
            height: 60,
            color: Colors.grey[300],
          ),
          // Years
          _buildStatItem(
            icon: Icons.access_time,
            value: '3',
            label: 'Years',
            iconSize: iconSize,
            valueFontSize: statValueFontSize,
            labelFontSize: statLabelFontSize,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required double iconSize,
    required double valueFontSize,
    required double labelFontSize,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: iconSize,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: labelFontSize,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(
    Size size,
    Function clampDouble,
    double labelFontSize,
    double valueFontSize,
    double spacing,
    double cardPadding,
    double borderRadius,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: clampDouble(size.width * 0.05, 16, 24)),
      padding: EdgeInsets.all(cardPadding),
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
      child: Column(
        children: [
          _buildDetailRow(
            'Member Since',
            'Dec 20, 2021',
            labelFontSize,
            valueFontSize,
            spacing,
          ),
          Divider(color: Colors.grey[300], height: 1),
          SizedBox(height: spacing * 0.75),
          _buildDetailRow(
            'Car Model',
            driver['vehicle'] ?? 'Toyota Corolla',
            labelFontSize,
            valueFontSize,
            spacing,
          ),
          Divider(color: Colors.grey[300], height: 1),
          SizedBox(height: spacing * 0.75),
          _buildDetailRow(
            'Color',
            driver['vehicleColor'] ?? 'White',
            labelFontSize,
            valueFontSize,
            spacing,
          ),
          Divider(color: Colors.grey[300], height: 1),
          SizedBox(height: spacing * 0.75),
          _buildDetailRow(
            'Plate Number',
            driver['licensePlate'] ?? 'NYC-3560',
            labelFontSize,
            valueFontSize,
            spacing,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    double labelFontSize,
    double valueFontSize,
    double spacing,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing * 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: labelFontSize,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    Size size,
    Function clampDouble,
    double buttonFontSize,
    double spacing,
    double horizontalPadding,
    double borderRadius,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          // Call Button (Outlined)
          Expanded(
            child: Builder(
              builder: (context) => OutlinedButton(
                onPressed: () {
                  // Handle call
                  _onCall(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: clampDouble(size.height * 0.02, 14, 18),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone,
                      color: const Color(0xFF4CAF50),
                      size: buttonFontSize * 1.2,
                    ),
                    SizedBox(width: spacing * 0.5),
                    Text(
                      'Call',
                      style: TextStyle(
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: spacing),
          // Chat Button (Filled)
          Expanded(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  // Handle chat
                  _onChat(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: clampDouble(size.height * 0.02, 14, 18),
                  ),
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: buttonFontSize * 1.2,
                    ),
                    SizedBox(width: spacing * 0.5),
                    Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onCall(BuildContext context) {
    // Navigate to voice call screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DriverVoiceCallScreen(driver: driver),
      ),
    );
  }

  void _onChat(BuildContext context) {
    // Navigate to chat screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DriverChatScreen(driver: driver),
      ),
    );
  }
}

