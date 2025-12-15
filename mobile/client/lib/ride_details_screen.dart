import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'cancel_ride_reason_screen.dart';
import 'driver_chat_screen.dart';

class RideDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> ride;

  const RideDetailsScreen({
    super.key,
    required this.ride,
  });

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  bool _driverFound = false;

  // Sample driver data
  final Map<String, dynamic> _driver = {
    'name': 'Michael Brown',
    'rating': 4.7,
    'vehicle': 'Toyota Camry',
    'vehicleColor': 'Black',
    'licensePlate': 'DEF-9012',
  };

  @override
  void initState() {
    super.initState();
    // After 10 seconds, driver is found
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _driverFound = true;
        });
        // Automatically show the modal after driver is found
        _showDriverFoundModal();
      }
    });
  }

  String _formatScheduledDate(DateTime date) {
    return DateFormat('EEEE, MMM d - hh:mm a').format(date);
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  void _showDriverFoundModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (context) => _buildDriverFoundModal(context),
    );
  }

  void _showShareReceiptModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (context) => _buildShareReceiptModal(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final cardTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final cardSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final detailLabelFontSize = clampDouble(size.width * 0.038, 13, 15);
    final detailValueFontSize = clampDouble(size.width * 0.038, 13, 15);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);

    // Check if ride is completed or cancelled (must be declared first)
    final isCompleted = widget.ride['completedDate'] != null || widget.ride['status'] == 'completed';
    final isCancelled = widget.ride['cancelledDate'] != null || widget.ride['status'] == 'cancelled';

    // Extract ride data with defaults
    final destination = widget.ride['destination'] ?? 'Destination';
    final rideType = widget.ride['rideType'] ?? 'car';
    final bookedDate = widget.ride['bookedDate'] as DateTime? ?? widget.ride['completedDate'] as DateTime? ?? widget.ride['cancelledDate'] as DateTime? ?? DateTime.now();
    final scheduledDate = widget.ride['scheduledDate'] as DateTime? ?? DateTime.now();
    final fare = widget.ride['fare'] as double? ?? 12.50;
    final originalFare = widget.ride['originalFare'] as double? ?? 15.00;
    final discount = originalFare - fare;
    final paymentMethod = widget.ride['paymentMethod'] ?? 'GoRide Wallet';
    final pickup = widget.ride['pickup'] ?? 'New York University';
    final transactionId = widget.ride['transactionId'] ?? 'TRX1221240956';
    final bookingId = widget.ride['bookingId'] ?? 'BKG926084';
    
    // Calculate driver tip and total paid
    final driverTip = widget.ride['driverTip'] as double? ?? (isCompleted ? 5.00 : 0.00);
    final totalPaid = widget.ride['totalPaid'] as double? ?? (isCompleted ? (fare + driverTip) : fare);
    
    // Update driver data for completed rides
    if (isCompleted) {
      _driver['name'] = 'Richard Davis';
      _driver['rating'] = 4.9;
      _driver['vehicle'] = 'Honda Accord';
      _driver['vehicleColor'] = 'White';
      _driver['licensePlate'] = 'XYZ-5678';
    }
    
    // Update driver data for cancelled rides
    if (isCancelled) {
      if (widget.ride['driver'] != null) {
        final driverData = widget.ride['driver'] as Map<String, dynamic>;
        _driver['name'] = driverData['name'] ?? 'Charles Martinez';
        _driver['rating'] = driverData['rating'] ?? 4.6;
        _driver['vehicle'] = driverData['vehicle'] ?? 'Yamaha FZ-07';
        _driver['vehicleColor'] = driverData['vehicleColor'] ?? 'Black';
        _driver['licensePlate'] = driverData['licensePlate'] ?? 'GHI-3456';
      } else {
        // Default driver for cancelled rides
        _driver['name'] = 'Charles Martinez';
        _driver['rating'] = 4.6;
        _driver['vehicle'] = 'Yamaha FZ-07';
        _driver['vehicleColor'] = 'Black';
        _driver['licensePlate'] = 'GHI-3456';
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, size, clampDouble, horizontalPadding),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Your Scheduled Ride Card (only show if not completed and not cancelled)
              if (!isCompleted && !isCancelled) ...[
                SizedBox(height: spacing),
                _buildScheduledRideCard(
                  context,
                  size,
                  clampDouble,
                  scheduledDate,
                  titleFontSize,
                  cardSubtitleFontSize,
                  spacing,
                  borderRadius,
                  _driverFound,
                ),
              ],
              SizedBox(height: spacing),
              // Ride Type and Cost Card
              _buildRideTypeCard(
                size,
                clampDouble,
                rideType,
                originalFare,
                fare,
                cardTitleFontSize,
                cardSubtitleFontSize,
                spacing,
                borderRadius,
                isCompleted,
                isCancelled,
              ),
              SizedBox(height: spacing),
              // Pickup and Dropoff Locations Card
              _buildLocationsCard(
                size,
                clampDouble,
                pickup,
                destination,
                cardTitleFontSize,
                spacing,
                borderRadius,
              ),
              // Driver Information Card (show when driver is found, ride is completed, or cancelled)
              if (_driverFound || isCompleted || isCancelled) ...[
                SizedBox(height: spacing),
                _buildDriverInformationCard(
                  size,
                  clampDouble,
                  cardTitleFontSize,
                  cardSubtitleFontSize,
                  spacing,
                  borderRadius,
                ),
              ],
              SizedBox(height: spacing),
              // Ride Details Information Card
              _buildRideDetailsCard(
                size,
                clampDouble,
                paymentMethod,
                bookedDate,
                transactionId,
                bookingId,
                detailLabelFontSize,
                detailValueFontSize,
                spacing,
                borderRadius,
                context,
                isCompleted,
                isCancelled,
              ),
              SizedBox(height: spacing),
              // Fare Breakdown Card
              _buildFareBreakdownCard(
                size,
                clampDouble,
                originalFare,
                discount,
                fare,
                driverTip,
                totalPaid,
                detailLabelFontSize,
                detailValueFontSize,
                spacing,
                borderRadius,
                isCompleted,
              ),
              SizedBox(height: spacing * 2),
              // Action Buttons
              _buildActionButtons(
                size,
                clampDouble,
                spacing,
                borderRadius,
                context,
                isCompleted,
                isCancelled,
              ),
              SizedBox(height: spacing),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Size size, Function clampDouble, double horizontalPadding) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Ride Details',
        style: TextStyle(
          fontSize: clampDouble(size.width * 0.055, 20, 24),
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

  Widget _buildScheduledRideCard(
    BuildContext context,
    Size size,
    Function clampDouble,
    DateTime scheduledDate,
    double titleFontSize,
    double subtitleFontSize,
    double spacing,
    double borderRadius,
    bool driverFound,
  ) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Scheduled Ride',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
          ),
          SizedBox(height: spacing * 0.5),
          Text(
            _formatScheduledDate(scheduledDate),
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: spacing),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: driverFound ? _showDriverFoundModal : null,
              icon: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  driverFound ? Icons.check_circle : Icons.info_outline,
                  color: const Color(0xFF4CAF50),
                  size: 16,
                ),
              ),
              label: Text(
                driverFound ? 'Driver is found' : 'We\'ll notify you when a driver\'s found',
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w500,
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
                disabledBackgroundColor: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideTypeCard(
    Size size,
    Function clampDouble,
    String rideType,
    double originalFare,
    double fare,
    double titleFontSize,
    double subtitleFontSize,
    double spacing,
    double borderRadius,
    bool isCompleted,
    bool isCancelled,
  ) {
    return Container(
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
              rideType == 'scooter' ? Icons.two_wheeler : Icons.directions_car,
              color: const Color(0xFF4CAF50),
              size: clampDouble(size.width * 0.06, 22, 28),
            ),
          ),
          SizedBox(width: spacing),
          // Ride Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCancelled && rideType == 'scooter'
                      ? 'GoRide Scooter'
                      : isCompleted
                          ? 'GoRide Car XL'
                          : 'GoRide Car',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: spacing * 0.25),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: subtitleFontSize * 1.2,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: spacing * 0.25),
                    Flexible(
                      child: Text(
                        isCompleted ? '5-7 mins' : '3-5 mins',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: spacing * 0.5),
                    Icon(
                      Icons.person,
                      size: subtitleFontSize * 1.2,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: spacing * 0.25),
                    Flexible(
                      child: Text(
                        isCancelled && rideType == 'scooter'
                            ? '1 passenger'
                            : isCompleted
                                ? '6 passengers'
                                : '4 passengers',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: isCancelled ? const Color(0xFF4CAF50) : const Color(0xFF4CAF50),
                    size: subtitleFontSize * 1.2,
                  ),
                  SizedBox(width: spacing * 0.25),
                  Text(
                    '\$${fare.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: isCancelled ? const Color(0xFF4CAF50) : const Color(0xFF212121),
                    ),
                  ),
                ],
              ),
              if (originalFare > fare) ...[
                SizedBox(height: spacing * 0.25),
                Text(
                  '\$${originalFare.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.grey[600],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationsCard(
    Size size,
    Function clampDouble,
    String pickup,
    String destination,
    double fontSize,
    double spacing,
    double borderRadius,
  ) {
    return Container(
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
      child: Column(
        children: [
          // Pickup Location
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: const Color(0xFF4CAF50),
                size: clampDouble(size.width * 0.06, 22, 28),
              ),
              SizedBox(width: spacing * 0.75),
              Expanded(
                child: Text(
                  pickup,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
              ),
            ],
          ),
          // Dashed Line
          Padding(
            padding: EdgeInsets.only(
              left: clampDouble(size.width * 0.03, 11, 14),
              top: spacing * 0.5,
              bottom: spacing * 0.5,
            ),
            child: Container(
              height: 20,
              width: 2,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(1),
              ),
              child: CustomPaint(
                painter: DashedLinePainter(),
              ),
            ),
          ),
          // Dropoff Location
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.red[400],
                size: clampDouble(size.width * 0.06, 22, 28),
              ),
              SizedBox(width: spacing * 0.75),
              Expanded(
                child: Text(
                  destination,
                  style: TextStyle(
                    fontSize: fontSize,
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

  Widget _buildDriverInformationCard(
    Size size,
    Function clampDouble,
    double titleFontSize,
    double subtitleFontSize,
    double spacing,
    double borderRadius,
  ) {
    final cardPadding = clampDouble(size.width * 0.05, 16, 24);
    final profileSize = clampDouble(size.width * 0.18, 60, 80);
    final chatButtonSize = clampDouble(size.width * 0.12, 48, 56);

    return Container(
      padding: EdgeInsets.all(cardPadding),
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
        children: [
          // Profile Picture
          Container(
            width: profileSize,
            height: profileSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              border: Border.all(
                color: const Color(0xFF4CAF50),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Container(
                color: Colors.grey[200],
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF4CAF50),
                  size: 30,
                ),
              ),
            ),
          ),
          SizedBox(width: spacing),
          // Driver Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _driver['name'] as String,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    SizedBox(width: spacing * 0.5),
                    Icon(
                      Icons.star,
                      size: titleFontSize * 0.9,
                      color: Colors.orange,
                    ),
                    SizedBox(width: spacing * 0.25),
                    Text(
                      '${_driver['rating']}',
                      style: TextStyle(
                        fontSize: titleFontSize * 0.9,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212121),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing * 0.25),
                Text(
                  '${_driver['vehicle']}, ${_driver['vehicleColor']} · ${_driver['licensePlate']}',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: spacing * 0.5),
          // Chat Button
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DriverChatScreen(driver: _driver),
                ),
              );
            },
            child: Container(
              width: chatButtonSize,
              height: chatButtonSize,
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF4CAF50),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideDetailsCard(
    Size size,
    Function clampDouble,
    String paymentMethod,
    DateTime bookedDate,
    String transactionId,
    String bookingId,
    double labelFontSize,
    double valueFontSize,
    double spacing,
    double borderRadius,
    BuildContext context,
    bool isCompleted,
    bool isCancelled,
  ) {
    return Container(
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
      child: Column(
        children: [
          _buildDetailRow(
            'Status',
            isCancelled ? 'Canceled & Refunded' : (isCompleted ? 'Completed' : 'Scheduled'),
            labelFontSize,
            valueFontSize,
            spacing,
            isStatus: true,
            isCompleted: isCompleted,
            isCancelled: isCancelled,
          ),
          SizedBox(height: spacing * 0.75),
          _buildDetailRow('Payment', paymentMethod, labelFontSize, valueFontSize, spacing),
          SizedBox(height: spacing * 0.75),
          _buildDetailRow('Date', _formatDate(bookedDate), labelFontSize, valueFontSize, spacing),
          SizedBox(height: spacing * 0.75),
          _buildDetailRow('Time', _formatTime(bookedDate), labelFontSize, valueFontSize, spacing),
          SizedBox(height: spacing * 0.75),
          _buildDetailRowWithCopy('Transaction ID', transactionId, labelFontSize, valueFontSize, spacing, context),
          SizedBox(height: spacing * 0.75),
          _buildDetailRowWithCopy('Booking ID', bookingId, labelFontSize, valueFontSize, spacing, context),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    double labelFontSize,
    double valueFontSize,
    double spacing, {
    bool isStatus = false,
    bool isDiscount = false,
    bool isCompleted = false,
    bool isCancelled = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            color: Colors.grey[700],
          ),
        ),
        if (isStatus)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing * 0.75,
              vertical: spacing * 0.25,
            ),
            decoration: BoxDecoration(
              color: isCancelled
                  ? Colors.red[50]
                  : isCompleted
                      ? Colors.green[50]
                      : Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w600,
                color: isCancelled
                    ? Colors.red[700]
                    : isCompleted
                        ? Colors.green[700]
                        : Colors.blue[700],
              ),
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.w600,
              color: isDiscount ? Colors.green[700] : const Color(0xFF212121),
            ),
          ),
      ],
    );
  }

  Widget _buildDetailRowWithCopy(
    String label,
    String value,
    double labelFontSize,
    double valueFontSize,
    double spacing,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            color: Colors.grey[700],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF212121),
              ),
            ),
            SizedBox(width: spacing * 0.5),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$label copied to clipboard'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Icon(
                Icons.copy,
                size: valueFontSize * 1.2,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFareBreakdownCard(
    Size size,
    Function clampDouble,
    double originalFare,
    double discount,
    double fare,
    double driverTip,
    double totalPaid,
    double labelFontSize,
    double valueFontSize,
    double spacing,
    double borderRadius,
    bool isCompleted,
  ) {
    // Calculate discount percentage
    final discountPercent = discount > 0 ? ((discount / originalFare) * 100).round() : 0;
    
    return Container(
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
      child: Column(
        children: [
          _buildDetailRow('Trip Fare', '\$${originalFare.toStringAsFixed(2)}', labelFontSize, valueFontSize, spacing),
          if (discount > 0) ...[
            SizedBox(height: spacing * 0.75),
            _buildDetailRow('Discounts ($discountPercent%)', '- \$${discount.toStringAsFixed(2)}', labelFontSize, valueFontSize, spacing, isDiscount: true),
          ],
          if (isCompleted && driverTip > 0) ...[
            SizedBox(height: spacing * 0.75),
            _buildDetailRow('Driver Tip', '\$${driverTip.toStringAsFixed(2)}', labelFontSize, valueFontSize, spacing),
          ],
          SizedBox(height: spacing * 0.75),
          Divider(color: Colors.grey[300], height: 1),
          SizedBox(height: spacing * 0.75),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Paid',
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
              Text(
                '\$${totalPaid.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    Size size,
    Function clampDouble,
    double spacing,
    double borderRadius,
    BuildContext context,
    bool isCompleted,
    bool isCancelled,
  ) {
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);

    return Column(
      children: [
        // Share Receipt Button (show for completed and cancelled rides)
        if (isCompleted || isCancelled)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _showShareReceiptModal,
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
                'Share Receipt',
                style: TextStyle(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4CAF50),
                ),
              ),
            ),
          ),
        // Cancel Ride Button (only show if not completed and not cancelled)
        if (!isCompleted && !isCancelled) ...[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _showShareReceiptModal,
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
                'Share Receipt',
                style: TextStyle(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4CAF50),
                ),
              ),
            ),
          ),
          SizedBox(height: spacing),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CancelRideReasonScreen(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: clampDouble(size.height * 0.02, 14, 18),
                ),
                side: const BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
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
        ],
      ],
    );
  }

  Widget _buildDriverFoundModal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final nameFontSize = clampDouble(size.width * 0.042, 14, 16);
    final vehicleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final iconSize = clampDouble(size.width * 0.2, 80, 100);
    final profileSize = clampDouble(size.width * 0.18, 60, 80);
    final chatButtonSize = clampDouble(size.width * 0.12, 48, 56);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius * 2),
            topRight: Radius.circular(borderRadius * 2),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: spacing),
                // Top Green Icon
                Transform.translate(
                  offset: Offset(0, -spacing * 2),
                  child: Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4CAF50).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                SizedBox(height: spacing * 0.5),
                // Title
                Text(
                  'We\'ve found the driver!',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing * 1.5),
                // Driver Information Card
                Container(
                  padding: EdgeInsets.all(horizontalPadding),
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
                    children: [
                      // Profile Picture
                      Container(
                        width: profileSize,
                        height: profileSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          border: Border.all(
                            color: const Color(0xFF4CAF50),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFF4CAF50),
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: spacing),
                      // Driver Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _driver['name'] as String,
                                  style: TextStyle(
                                    fontSize: nameFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF212121),
                                  ),
                                ),
                                SizedBox(width: spacing * 0.5),
                                Icon(
                                  Icons.star,
                                  size: nameFontSize * 0.9,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: spacing * 0.25),
                                Text(
                                  '${_driver['rating']}',
                                  style: TextStyle(
                                    fontSize: nameFontSize * 0.9,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF212121),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: spacing * 0.25),
                            Text(
                              '${_driver['vehicle']}, ${_driver['vehicleColor']} - ${_driver['licensePlate']}',
                              style: TextStyle(
                                fontSize: vehicleFontSize,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: spacing * 0.5),
                      // Chat Button
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DriverChatScreen(driver: _driver),
                            ),
                          );
                        },
                        child: Container(
                          width: chatButtonSize,
                          height: chatButtonSize,
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF4CAF50),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline,
                            color: Color(0xFF4CAF50),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                // Got It Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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
                      'Got It',
                      style: TextStyle(
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  Widget _buildShareReceiptModal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final sectionLabelFontSize = clampDouble(size.width * 0.035, 12, 14);
    final nameFontSize = clampDouble(size.width * 0.032, 11, 13);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final profileSize = clampDouble(size.width * 0.14, 50, 60);
    final socialIconSize = clampDouble(size.width * 0.18, 60, 70);

    // Extract transaction and booking IDs for filename
    final transactionId = widget.ride['transactionId'] ?? 'TRX1221240956';
    final bookingId = widget.ride['bookingId'] ?? 'BKG926084';
    final fileName = 'IMG-$transactionId-$bookingId.jpg';

    // Recent people data
    final recentPeople = [
      {'name': 'Charlotte Hanlin', 'icon': Icons.chat, 'color': Colors.green},
      {'name': 'Kristin Watson', 'icon': Icons.facebook, 'color': Colors.blue},
      {'name': 'Clinton McClure', 'icon': Icons.camera_alt, 'color': Colors.orange},
      {'name': 'Maryland Winkles', 'icon': Icons.chat, 'color': Colors.green},
      {'name': 'Ale Her', 'icon': Icons.person, 'color': Colors.grey},
    ];

    // Social media apps
    final socialApps = [
      {'name': 'WhatsApp', 'icon': Icons.chat, 'color': Colors.green},
      {'name': 'Facebook', 'icon': Icons.facebook, 'color': Colors.blue},
      {'name': 'Instagram', 'icon': Icons.camera_alt, 'color': Colors.purple},
      {'name': 'Telegram', 'icon': Icons.send, 'color': Colors.blue},
      {'name': 'X', 'icon': Icons.close, 'color': Colors.black},
    ];

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius * 2),
            topRight: Radius.circular(borderRadius * 2),
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
                SizedBox(height: spacing * 0.5),
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: spacing),
                // Title
                Text(
                  'Share Receipt',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: spacing),
                // File Preview
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
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.description,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: Text(
                          fileName,
                          style: TextStyle(
                            fontSize: clampDouble(size.width * 0.038, 13, 15),
                            color: const Color(0xFF212121),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                // Recent people section
                Text(
                  'Recent people',
                  style: TextStyle(
                    fontSize: sectionLabelFontSize,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: spacing * 0.75),
                SizedBox(
                  height: profileSize + spacing * 1.5,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentPeople.length,
                    itemBuilder: (context, index) {
                      final person = recentPeople[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < recentPeople.length - 1 ? spacing * 0.75 : 0,
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Sharing with ${person['name']}'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: profileSize,
                                    height: profileSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200],
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Container(
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.grey[600],
                                          size: profileSize * 0.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Social media icon overlay
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: profileSize * 0.35,
                                      height: profileSize * 0.35,
                                      decoration: BoxDecoration(
                                        color: person['color'] as Color,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        person['icon'] as IconData,
                                        color: Colors.white,
                                        size: profileSize * 0.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: spacing * 0.25),
                            SizedBox(
                              width: profileSize + spacing,
                              child: Text(
                                person['name'] as String,
                                style: TextStyle(
                                  fontSize: nameFontSize,
                                  color: const Color(0xFF212121),
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                // Social media section
                Text(
                  'Social media',
                  style: TextStyle(
                    fontSize: sectionLabelFontSize,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: spacing * 0.75),
                SizedBox(
                  height: socialIconSize + spacing * 1.5,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: socialApps.length,
                    itemBuilder: (context, index) {
                      final app = socialApps[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < socialApps.length - 1 ? spacing * 0.75 : 0,
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Sharing via ${app['name']}'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Container(
                                width: socialIconSize,
                                height: socialIconSize,
                                decoration: BoxDecoration(
                                  color: app['color'] as Color,
                                  borderRadius: BorderRadius.circular(borderRadius),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  app['icon'] as IconData,
                                  color: Colors.white,
                                  size: socialIconSize * 0.4,
                                ),
                              ),
                            ),
                            SizedBox(height: spacing * 0.25),
                            SizedBox(
                              width: socialIconSize,
                              child: Text(
                                app['name'] as String,
                                style: TextStyle(
                                  fontSize: nameFontSize,
                                  color: const Color(0xFF212121),
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
}

// Custom painter for dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

