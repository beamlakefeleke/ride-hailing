import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'driver_en_route_screen.dart';
import 'ride_details_screen.dart';
import 'top_up_details_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedTabIndex = 0; // 0: Ongoing, 1: Scheduled, 2: Completed, 3: Cancelled

  // Sample ongoing ride data
  final Map<String, dynamic>? _ongoingRide = {
    'destination': 'Larchmont Hotel',
    'fare': 10.00,
    'date': DateTime(2024, 12, 22, 9, 41),
    'paymentMethod': 'GoRide Wallet',
    'pickup': 'Bobst Library',
    'dropoff': 'Larchmont Hotel',
    'pickupLat': 40.7295,
    'pickupLng': -73.9965,
    'dropoffLat': 40.7308,
    'dropoffLng': -73.9973,
  };

  // Sample cancelled rides data
  final List<Map<String, dynamic>> _cancelledRides = [
    {
      'destination': 'Madison Square Park',
      'rideType': 'scooter',
      'cancelledDate': DateTime(2024, 12, 20, 8, 49),
      'bookedDate': DateTime(2024, 12, 20, 8, 30),
      'fare': 5.60,
      'originalFare': 7.00,
      'paymentMethod': 'Visa (... 5567)',
      'pickup': 'Museum of Illusions',
      'transactionId': 'TRX1220240849',
      'bookingId': 'BKG803658',
      'status': 'cancelled',
      'driver': {
        'name': 'Charles Martinez',
        'rating': 4.6,
        'vehicle': 'Yamaha FZ-07',
        'vehicleColor': 'Black',
        'licensePlate': 'GHI-3456',
      },
    },
    {
      'destination': 'Hudson River Park',
      'rideType': 'car',
      'cancelledDate': DateTime(2024, 12, 17, 15, 42),
      'bookedDate': DateTime(2024, 12, 17, 15, 30),
      'fare': 14.75,
      'originalFare': 18.00,
      'paymentMethod': 'GoRide Wallet',
      'pickup': 'New York University',
      'transactionId': 'TRX1217241542',
      'bookingId': 'BKG803659',
      'status': 'cancelled',
    },
    {
      'destination': 'The Altman Building',
      'rideType': 'car',
      'cancelledDate': DateTime(2024, 12, 15, 20, 35),
      'bookedDate': DateTime(2024, 12, 15, 20, 20),
      'fare': 12.50,
      'originalFare': 15.00,
      'paymentMethod': 'PayPal',
      'pickup': 'Bobst Library',
      'transactionId': 'TRX1215242035',
      'bookingId': 'BKG803660',
      'status': 'cancelled',
    },
    {
      'destination': 'Chelsea Market',
      'rideType': 'scooter',
      'cancelledDate': DateTime(2024, 12, 12, 10, 4),
      'bookedDate': DateTime(2024, 12, 12, 9, 50),
      'fare': 5.50,
      'originalFare': 6.50,
      'paymentMethod': 'Apple Pay',
      'pickup': 'New York University',
      'transactionId': 'TRX1212241004',
      'bookingId': 'BKG803661',
      'status': 'cancelled',
    },
    {
      'destination': 'New York Comedy Club',
      'rideType': 'car',
      'cancelledDate': DateTime(2024, 12, 8, 19, 38),
      'bookedDate': DateTime(2024, 12, 8, 19, 25),
      'fare': 14.00,
      'originalFare': 17.00,
      'paymentMethod': 'Google Pay',
      'pickup': 'Bobst Library',
      'transactionId': 'TRX1208241938',
      'bookingId': 'BKG803662',
      'status': 'cancelled',
    },
    {
      'destination': 'The Home Depot',
      'rideType': 'car',
      'cancelledDate': DateTime(2024, 12, 6, 11, 45),
      'bookedDate': DateTime(2024, 12, 6, 11, 30),
      'fare': 15.25,
      'originalFare': 18.00,
      'paymentMethod': 'Visa (... 5567)',
      'pickup': 'New York University',
      'transactionId': 'TRX1206241145',
      'bookingId': 'BKG803663',
      'status': 'cancelled',
    },
    {
      'destination': 'Whole Foods Market',
      'rideType': 'scooter',
      'cancelledDate': DateTime(2024, 12, 3, 9, 48),
      'bookedDate': DateTime(2024, 12, 3, 9, 35),
      'fare': 6.50,
      'originalFare': 7.50,
      'paymentMethod': 'GoRide Wallet',
      'pickup': 'Bobst Library',
      'transactionId': 'TRX1203240948',
      'bookingId': 'BKG803664',
      'status': 'cancelled',
    },
  ];

  // Sample top-up transactions data
  final List<Map<String, dynamic>> _topUpTransactions = [
    {
      'amount': 250.00,
      'date': DateTime(2024, 12, 18, 20, 35),
      'paymentMethod': 'Mastercard',
      'cardLast4': '4679',
      'transactionId': 'TRX1218242035',
      'status': 'completed',
    },
    {
      'amount': 125.00,
      'date': DateTime(2024, 12, 16, 10, 6),
      'paymentMethod': 'PayPal',
      'transactionId': 'TRX1216241006',
      'status': 'completed',
    },
    {
      'amount': 50.00,
      'date': DateTime(2024, 12, 12, 18, 28),
      'paymentMethod': 'Google Pay',
      'transactionId': 'TRX1212241828',
      'status': 'completed',
    },
    {
      'amount': 100.00,
      'date': DateTime(2024, 12, 4, 11, 40),
      'paymentMethod': 'Visa',
      'cardLast4': '5567',
      'transactionId': 'TRX1204241140',
      'status': 'completed',
    },
    {
      'amount': 150.00,
      'date': DateTime(2024, 11, 29, 21, 58),
      'paymentMethod': 'Apple Pay',
      'transactionId': 'TRX1129242158',
      'status': 'completed',
    },
    {
      'amount': 125.00,
      'date': DateTime(2024, 11, 24, 9, 40),
      'paymentMethod': 'Mastercard',
      'cardLast4': '4679',
      'transactionId': 'TRX1124240940',
      'status': 'completed',
    },
    {
      'amount': 75.00,
      'date': DateTime(2024, 11, 20, 10, 57),
      'paymentMethod': 'PayPal',
      'transactionId': 'TRX1120241057',
      'status': 'completed',
    },
  ];

  // Sample completed rides data
  final List<Map<String, dynamic>> _completedRides = [
    {
      'destination': 'Jefferson Market Library',
      'rideType': 'car',
      'completedDate': DateTime(2024, 12, 21, 9, 56),
      'bookedDate': DateTime(2024, 12, 21, 9, 41),
      'fare': 12.75,
      'originalFare': 15.00,
      'driverTip': 5.00,
      'totalPaid': 17.75,
      'paymentMethod': 'GoRide Wallet',
      'pickup': 'New York University',
      'transactionId': 'TRX1221240956',
      'bookingId': 'BKG926084',
      'status': 'completed',
    },
    {
      'destination': 'Cinema Village',
      'rideType': 'scooter',
      'completedDate': DateTime(2024, 12, 20, 16, 49),
      'fare': 6.50,
      'paymentMethod': 'PayPal',
    },
    {
      'destination': 'New York University',
      'rideType': 'car',
      'completedDate': DateTime(2024, 12, 20, 8, 25),
      'fare': 10.00,
      'paymentMethod': 'Cash',
    },
    {
      'destination': 'Independent Training Academy',
      'rideType': 'car',
      'completedDate': DateTime(2024, 12, 19, 20, 7),
      'fare': 12.50,
      'paymentMethod': 'GoRide Wallet',
    },
    {
      'destination': 'Boqueria Soho',
      'rideType': 'scooter',
      'completedDate': DateTime(2024, 12, 19, 12, 32),
      'fare': 5.50,
      'paymentMethod': 'Apple Pay',
    },
    {
      'destination': 'Rubin Museum of Art',
      'rideType': 'car',
      'completedDate': DateTime(2024, 12, 18, 10, 44),
      'fare': 16.25,
      'paymentMethod': 'Google Pay',
    },
    {
      'destination': 'The Joyce Theater',
      'rideType': 'car',
      'completedDate': DateTime(2024, 12, 17, 18, 57),
      'fare': 12.50,
      'paymentMethod': 'Visa',
    },
  ];

  // Sample scheduled rides data
  final List<Map<String, dynamic>> _scheduledRides = [
    {
      'destination': 'Larchmont Hotel',
      'rideType': 'car', // 'car' or 'scooter'
      'bookedDate': DateTime(2024, 12, 22, 9, 41),
      'scheduledDate': DateTime(2024, 12, 23, 16, 0),
      'pickup': 'Bobst Library',
      'fare': 10.00,
      'originalFare': 12.50,
      'paymentMethod': 'GoRide Wallet',
      'transactionId': 'TRX1222240941',
      'bookingId': 'BKG720469',
    },
    {
      'destination': 'Strand Book Store',
      'rideType': 'scooter',
      'bookedDate': DateTime(2024, 12, 21, 14, 25),
      'scheduledDate': DateTime(2024, 12, 24, 10, 30),
      'pickup': 'Bobst Library',
      'fare': 8.00,
      'originalFare': 10.00,
      'paymentMethod': 'GoRide Wallet',
      'transactionId': 'TRX1221211425',
      'bookingId': 'BKG720470',
    },
    {
      'destination': 'Angelika Film Center & Cafe',
      'rideType': 'car',
      'bookedDate': DateTime(2024, 12, 21, 10, 8),
      'scheduledDate': DateTime(2024, 12, 24, 19, 0),
      'pickup': 'Bobst Library',
      'fare': 12.00,
      'originalFare': 15.00,
      'paymentMethod': 'GoRide Wallet',
      'transactionId': 'TRX1221211008',
      'bookingId': 'BKG720471',
    },
    {
      'destination': 'Beacon\'s Closet',
      'rideType': 'scooter',
      'bookedDate': DateTime(2024, 12, 20, 8, 46),
      'scheduledDate': DateTime(2024, 12, 25, 14, 30),
      'pickup': 'Bobst Library',
      'fare': 7.50,
      'originalFare': 9.00,
      'paymentMethod': 'GoRide Wallet',
      'transactionId': 'TRX1220200846',
      'bookingId': 'BKG720472',
    },
  ];

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final rideDate = DateTime(date.year, date.month, date.day);

    if (rideDate == today) {
      return 'Today, ${DateFormat('MMM d, yyyy').format(date)} - ${DateFormat('hh:mm a').format(date)}';
    } else {
      return DateFormat('MMM d, yyyy - hh:mm a').format(date);
    }
  }

  String _formatScheduledTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  String _formatScheduledDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  String _formatCompletedDate(DateTime date) {
    return DateFormat('MMM d, yyyy - hh:mm a').format(date);
  }

  String _formatCancelledDate(DateTime date) {
    return DateFormat('MMM d, yyyy - hh:mm a').format(date);
  }

  String _formatTopUpDate(DateTime date) {
    return DateFormat('MMM d, yyyy · hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final tabFontSize = clampDouble(size.width * 0.038, 13, 15);
    final cardTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final cardSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final buttonFontSize = clampDouble(size.width * 0.038, 13, 15);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final tabPadding = clampDouble(size.width * 0.03, 10, 14);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(size, clampDouble, horizontalPadding),
      body: Column(
        children: [
          // Horizontal Navigation Tabs
          _buildTabs(size, clampDouble, tabFontSize, tabPadding, borderRadius),
          // Content
          Expanded(
            child: _buildContent(
              size,
              clampDouble,
              horizontalPadding,
              cardTitleFontSize,
              cardSubtitleFontSize,
              buttonFontSize,
              spacing,
              borderRadius,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Size size, Function clampDouble, double horizontalPadding) {
    final logoSize = clampDouble(size.width * 0.08, 32, 40);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(horizontalPadding * 0.5),
        child: Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'Go',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        'Activity',
        style: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF212121),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Color(0xFF212121)),
          onPressed: () {
            // Handle menu
          },
        ),
      ],
    );
  }

  Widget _buildTabs(
    Size size,
    Function clampDouble,
    double fontSize,
    double padding,
    double borderRadius,
  ) {
    final tabs = ['Ongoing', 'Scheduled', 'Completed', 'Cancelled', 'Top Up'];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: clampDouble(size.width * 0.05, 16, 24),
        vertical: clampDouble(size.height * 0.015, 10, 16),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = _selectedTabIndex == index;
            return Padding(
              padding: EdgeInsets.only(
                right: index < tabs.length - 1 ? padding * 0.75 : 0,
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding,
                    vertical: padding * 0.6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF4CAF50)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius * 2),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4CAF50)
                          : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
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
      ),
    );
  }

  Widget _buildContent(
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double cardTitleFontSize,
    double cardSubtitleFontSize,
    double buttonFontSize,
    double spacing,
    double borderRadius,
  ) {
    if (_selectedTabIndex == 0) {
      // Ongoing tab
      return _buildOngoingContent(
        size,
        clampDouble,
        horizontalPadding,
        cardTitleFontSize,
        cardSubtitleFontSize,
        buttonFontSize,
        spacing,
        borderRadius,
      );
    } else if (_selectedTabIndex == 1) {
      // Scheduled tab
      return _buildScheduledContent(size, clampDouble, horizontalPadding, spacing);
    } else if (_selectedTabIndex == 2) {
      // Completed tab
      return _buildCompletedContent(size, clampDouble, horizontalPadding, spacing);
    } else if (_selectedTabIndex == 3) {
      // Cancelled tab
      return _buildCancelledContent(size, clampDouble, horizontalPadding, spacing);
    } else {
      // Top Up tab
      return _buildTopUpContent(size, clampDouble, horizontalPadding, spacing);
    }
  }

  Widget _buildOngoingContent(
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double cardTitleFontSize,
    double cardSubtitleFontSize,
    double buttonFontSize,
    double spacing,
    double borderRadius,
  ) {
    if (_ongoingRide == null) {
      return Center(
        child: Text(
          'No ongoing rides',
          style: TextStyle(
            fontSize: cardTitleFontSize,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(horizontalPadding),
      child: _buildOngoingRideCard(
        size,
        clampDouble,
        horizontalPadding,
        cardTitleFontSize,
        cardSubtitleFontSize,
        buttonFontSize,
        spacing,
        borderRadius,
      ),
    );
  }

  Widget _buildOngoingRideCard(
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double cardTitleFontSize,
    double cardSubtitleFontSize,
    double buttonFontSize,
    double spacing,
    double borderRadius,
  ) {
    return Container(
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
      child: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Car icon, Destination, Fare
            Row(
              children: [
                // Car Icon
                Container(
                  padding: EdgeInsets.all(spacing * 0.5),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(borderRadius * 0.5),
                    border: Border.all(
                      color: const Color(0xFF4CAF50),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.directions_car,
                    color: const Color(0xFF4CAF50),
                    size: clampDouble(size.width * 0.06, 22, 28),
                  ),
                ),
                SizedBox(width: spacing),
                // Destination
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _ongoingRide!['destination'] as String,
                        style: TextStyle(
                          fontSize: cardTitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      SizedBox(height: spacing * 0.25),
                      Text(
                        _formatDate(_ongoingRide['date'] as DateTime),
                        style: TextStyle(
                          fontSize: cardSubtitleFontSize,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Fare
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${(_ongoingRide['fare'] as double).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: cardTitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      _ongoingRide['paymentMethod'] as String,
                      style: TextStyle(
                        fontSize: cardSubtitleFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: spacing * 1.5),
            // Route Information
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location pins column
                Column(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: const Color(0xFF4CAF50),
                      size: clampDouble(size.width * 0.06, 22, 28),
                    ),
                    Container(
                      width: 2,
                      height: spacing * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    Icon(
                      Icons.location_on,
                      color: Colors.red[400],
                      size: clampDouble(size.width * 0.06, 22, 28),
                    ),
                  ],
                ),
                SizedBox(width: spacing * 0.75),
                // Location names column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _ongoingRide['pickup'] as String,
                        style: TextStyle(
                          fontSize: cardSubtitleFontSize,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      SizedBox(height: spacing * 0.8),
                      Text(
                        _ongoingRide['dropoff'] as String,
                        style: TextStyle(
                          fontSize: cardSubtitleFontSize,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing * 1.5),
            // Track Route Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to driver en route screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DriverEnRouteScreen(
                        destination: {
                          'name': _ongoingRide['dropoff'],
                          'lat': _ongoingRide['dropoffLat'],
                          'lng': _ongoingRide['dropoffLng'],
                        },
                        pickupLocation: {
                          'name': _ongoingRide['pickup'],
                          'lat': _ongoingRide['pickupLat'],
                          'lng': _ongoingRide['pickupLng'],
                        },
                        selectedRide: {
                          'name': 'GoRide Car',
                          'price': _ongoingRide['fare'],
                        },
                        selectedPayment: {
                          'name': _ongoingRide['paymentMethod'],
                        },
                        selectedPromo: null,
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: clampDouble(size.height * 0.02, 14, 18),
                  ),
                  side: const BorderSide(
                    color: Color(0xFF4CAF50),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
                child: Text(
                  'Track Route',
                  style: TextStyle(
                    fontSize: buttonFontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduledContent(
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double spacing,
  ) {
    if (_scheduledRides.isEmpty) {
      return Center(
        child: Text(
          'No scheduled rides',
          style: TextStyle(
            fontSize: clampDouble(size.width * 0.042, 14, 16),
            color: Colors.grey[600],
          ),
        ),
      );
    }

    final cardTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final cardSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final iconContainerSize = clampDouble(size.width * 0.14, 48, 56);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: spacing * 0.5),
      itemCount: _scheduledRides.length,
      itemBuilder: (context, index) {
        final ride = _scheduledRides[index];
        return _buildScheduledRideItem(
          size,
          clampDouble,
          ride,
          cardTitleFontSize,
          cardSubtitleFontSize,
          iconSize,
          iconContainerSize,
          spacing,
          index < _scheduledRides.length - 1,
        );
      },
    );
  }

  Widget _buildScheduledRideItem(
    Size size,
    Function clampDouble,
    Map<String, dynamic> ride,
    double titleFontSize,
    double subtitleFontSize,
    double iconSize,
    double iconContainerSize,
    double spacing,
    bool showDivider,
  ) {
    final rideType = ride['rideType'] as String;
    final bookedDate = ride['bookedDate'] as DateTime;
    final scheduledDate = ride['scheduledDate'] as DateTime;

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RideDetailsScreen(ride: ride),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  width: iconContainerSize,
                  height: iconContainerSize,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4CAF50),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    rideType == 'scooter' ? Icons.two_wheeler : Icons.directions_car,
                    color: const Color(0xFF4CAF50),
                    size: iconSize,
                  ),
                ),
                SizedBox(width: spacing),
                // Destination and Booking Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride['destination'] as String,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing * 0.25),
                      Text(
                        _formatDate(bookedDate),
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacing * 0.5),
                // Scheduled Time and Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatScheduledTime(scheduledDate),
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      _formatScheduledDate(scheduledDate),
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
          ),
      ],
    );
  }

  Widget _buildCompletedContent(
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double spacing,
  ) {
    if (_completedRides.isEmpty) {
      return Center(
        child: Text(
          'No completed rides',
          style: TextStyle(
            fontSize: clampDouble(size.width * 0.042, 14, 16),
            color: Colors.grey[600],
          ),
        ),
      );
    }

    final cardTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final cardSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final iconContainerSize = clampDouble(size.width * 0.14, 48, 56);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: spacing * 0.5),
      itemCount: _completedRides.length,
      itemBuilder: (context, index) {
        final ride = _completedRides[index];
        return _buildCompletedRideItem(
          size,
          clampDouble,
          ride,
          cardTitleFontSize,
          cardSubtitleFontSize,
          iconSize,
          iconContainerSize,
          spacing,
          index < _completedRides.length - 1,
        );
      },
    );
  }

  Widget _buildCompletedRideItem(
    Size size,
    Function clampDouble,
    Map<String, dynamic> ride,
    double titleFontSize,
    double subtitleFontSize,
    double iconSize,
    double iconContainerSize,
    double spacing,
    bool showDivider,
  ) {
    final rideType = ride['rideType'] as String;
    final completedDate = ride['completedDate'] as DateTime;
    final fare = ride['fare'] as double;
    final paymentMethod = ride['paymentMethod'] as String;

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RideDetailsScreen(ride: ride),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                width: iconContainerSize,
                height: iconContainerSize,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF4CAF50),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  rideType == 'scooter' ? Icons.two_wheeler : Icons.directions_car,
                  color: const Color(0xFF4CAF50),
                  size: iconSize,
                ),
              ),
              SizedBox(width: spacing),
              // Destination and Completion Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride['destination'] as String,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      _formatCompletedDate(completedDate),
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing * 0.5),
              // Fare and Payment Method
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${fare.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: spacing * 0.25),
                  Text(
                    paymentMethod,
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
          ),
      ],
    );
  }

  Widget _buildCancelledContent(
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double spacing,
  ) {
    if (_cancelledRides.isEmpty) {
      return Center(
        child: Text(
          'No cancelled rides',
          style: TextStyle(
            fontSize: clampDouble(size.width * 0.042, 14, 16),
            color: Colors.grey[600],
          ),
        ),
      );
    }

    final cardTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final cardSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final statusFontSize = clampDouble(size.width * 0.032, 11, 13);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final iconContainerSize = clampDouble(size.width * 0.14, 48, 56);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: spacing * 0.5),
      itemCount: _cancelledRides.length,
      itemBuilder: (context, index) {
        final ride = _cancelledRides[index];
        return _buildCancelledRideItem(
          size,
          clampDouble,
          ride,
          cardTitleFontSize,
          cardSubtitleFontSize,
          statusFontSize,
          iconSize,
          iconContainerSize,
          spacing,
          index < _cancelledRides.length - 1,
        );
      },
    );
  }

  Widget _buildCancelledRideItem(
    Size size,
    Function clampDouble,
    Map<String, dynamic> ride,
    double titleFontSize,
    double subtitleFontSize,
    double statusFontSize,
    double iconSize,
    double iconContainerSize,
    double spacing,
    bool showDivider,
  ) {
    final rideType = ride['rideType'] as String;
    final cancelledDate = ride['cancelledDate'] as DateTime;
    final fare = ride['fare'] as double;

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RideDetailsScreen(ride: ride),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  width: iconContainerSize,
                  height: iconContainerSize,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4CAF50),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    rideType == 'scooter' ? Icons.two_wheeler : Icons.directions_car,
                    color: const Color(0xFF4CAF50),
                    size: iconSize,
                  ),
                ),
                SizedBox(width: spacing),
                // Destination and Cancellation Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride['destination'] as String,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing * 0.25),
                      Text(
                        _formatCancelledDate(cancelledDate),
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacing * 0.5),
                // Fare and Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${fare.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      'Canceled & Refunded',
                      style: TextStyle(
                        fontSize: statusFontSize,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
          ),
      ],
    );
  }

  Widget _buildTopUpContent(
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double spacing,
  ) {
    if (_topUpTransactions.isEmpty) {
      return Center(
        child: Text(
          'No top-up transactions',
          style: TextStyle(
            fontSize: clampDouble(size.width * 0.042, 14, 16),
            color: Colors.grey[600],
          ),
        ),
      );
    }

    final cardTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final cardSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final iconContainerSize = clampDouble(size.width * 0.14, 48, 56);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: spacing * 0.5),
      itemCount: _topUpTransactions.length,
      itemBuilder: (context, index) {
        final transaction = _topUpTransactions[index];
        return _buildTopUpItem(
          size,
          clampDouble,
          transaction,
          cardTitleFontSize,
          cardSubtitleFontSize,
          iconSize,
          iconContainerSize,
          spacing,
          index < _topUpTransactions.length - 1,
        );
      },
    );
  }

  Widget _buildTopUpItem(
    Size size,
    Function clampDouble,
    Map<String, dynamic> transaction,
    double titleFontSize,
    double subtitleFontSize,
    double iconSize,
    double iconContainerSize,
    double spacing,
    bool showDivider,
  ) {
    final amount = transaction['amount'] as double;
    final date = transaction['date'] as DateTime;
    final paymentMethod = transaction['paymentMethod'] as String;

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TopUpDetailsScreen(transaction: transaction),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  width: iconContainerSize,
                  height: iconContainerSize,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: const Color(0xFF4CAF50),
                    size: iconSize,
                  ),
                ),
                SizedBox(width: spacing),
                // Top Up and Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Top Up',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      SizedBox(height: spacing * 0.25),
                      Text(
                        _formatTopUpDate(date),
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacing * 0.5),
                // Amount and Payment Method
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      paymentMethod,
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
          ),
      ],
    );
  }
}

