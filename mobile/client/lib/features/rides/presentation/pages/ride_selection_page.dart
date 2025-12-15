import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/injections/injection_container.dart';
import '../bloc/ride_bloc.dart';
import '../bloc/ride_event.dart';
import '../bloc/ride_state.dart';
import 'driver_search_page.dart';
import '../../../../features/payment/presentation/pages/payment_method_page.dart';
import 'schedule_ride_page.dart';

class RideSelectionPage extends StatefulWidget {
  final Map<String, dynamic> destination;
  final Map<String, dynamic> pickupLocation;

  const RideSelectionPage({
    super.key,
    required this.destination,
    required this.pickupLocation,
  });

  @override
  State<RideSelectionPage> createState() => _RideSelectionPageState();
}

class _RideSelectionPageState extends State<RideSelectionPage> {
  int _selectedRideIndex = 0;
  Map<String, dynamic>? _selectedPayment;
  DateTime? _scheduledDateTime;

  final List<Map<String, dynamic>> _rideOptions = [
    {
      'name': 'GoRide Car',
      'icon': Icons.directions_car,
      'arrival': '3-5 mins',
      'passengers': '4 passengers',
      'rideType': 'CAR',
      'isXL': false,
      'isPlus': false,
    },
    {
      'name': 'GoRide Car XL',
      'icon': Icons.airport_shuttle,
      'arrival': '4-6 mins',
      'passengers': '6 passengers',
      'rideType': 'CAR_XL',
      'isXL': true,
      'isPlus': false,
    },
    {
      'name': 'GoRide Car Plus',
      'icon': Icons.directions_car,
      'arrival': '4-5 mins',
      'passengers': '4 passengers',
      'rideType': 'CAR_PLUS',
      'isXL': false,
      'isPlus': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Estimate price for selected ride type
    _estimatePrice();
  }

  void _estimatePrice() {
    final selectedRide = _rideOptions[_selectedRideIndex];
    context.read<RideBloc>().add(
          EstimatePriceEvent(
            pickupLatitude: (widget.pickupLocation['latitude'] as num?)?.toDouble() ?? 0.0,
            pickupLongitude: (widget.pickupLocation['longitude'] as num?)?.toDouble() ?? 0.0,
            destinationLatitude: (widget.destination['latitude'] as num?)?.toDouble() ?? 0.0,
            destinationLongitude: (widget.destination['longitude'] as num?)?.toDouble() ?? 0.0,
            rideType: selectedRide['rideType'] as String,
          ),
        );
  }

  void _onRideSelected(int index) {
    setState(() {
      _selectedRideIndex = index;
    });
    _estimatePrice();
  }

  void _bookRide() {
    final selectedRide = _rideOptions[_selectedRideIndex];
    final state = context.read<RideBloc>().state;
    
    if (state is PriceEstimated) {
      context.read<RideBloc>().add(
            BookRideEvent(
              pickupLatitude: (widget.pickupLocation['latitude'] as num?)?.toDouble() ?? 0.0,
              pickupLongitude: (widget.pickupLocation['longitude'] as num?)?.toDouble() ?? 0.0,
              pickupAddress: widget.pickupLocation['address'] as String? ?? '',
              destinationLatitude: (widget.destination['latitude'] as num?)?.toDouble() ?? 0.0,
              destinationLongitude: (widget.destination['longitude'] as num?)?.toDouble() ?? 0.0,
              destinationAddress: widget.destination['address'] as String? ?? '',
              rideType: selectedRide['rideType'] as String,
              price: state.estimate.price,
              scheduledDateTime: _scheduledDateTime,
            ),
          );
    }
  }

  String _formatScheduleDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatScheduleTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final priceFontSize = clampDouble(size.width * 0.045, 16, 18);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonPadding = clampDouble(size.height * 0.022, 14, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final cardIconSize = clampDouble(size.width * 0.1, 40, 50);

    return BlocProvider(
      create: (context) => sl<RideBloc>(),
      child: Container(
        height: size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: BlocConsumer<RideBloc, RideState>(
          listener: (context, state) {
            if (state is RideBooked) {
              Navigator.of(context).pop(); // Close ride selection
              Navigator.of(context).pop(); // Close pickup location
              // Navigate to driver search screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DriverSearchPage(
                    rideId: state.ride.id,
                    destination: {
                      'name': widget.destination['name'] ?? '',
                      'address': widget.destination['address'] ?? '',
                      'lat': state.ride.destinationLatitude,
                      'lng': state.ride.destinationLongitude,
                    },
                    pickupLocation: {
                      'name': widget.pickupLocation['name'] ?? '',
                      'address': widget.pickupLocation['address'] ?? '',
                      'lat': state.ride.pickupLatitude,
                      'lng': state.ride.pickupLongitude,
                    },
                    selectedRide: {
                      'name': _rideOptions[_selectedRideIndex]['name'],
                      'rideType': state.ride.rideType,
                    },
                  ),
                ),
              );
            } else if (state is RideError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return _buildContent(
              context,
              size,
              clampDouble,
              horizontalPadding,
              titleFontSize,
              priceFontSize,
              buttonFontSize,
              buttonPadding,
              borderRadius,
              spacing,
              iconSize,
              cardIconSize,
              state,
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double titleFontSize,
    double priceFontSize,
    double buttonFontSize,
    double buttonPadding,
    double borderRadius,
    double spacing,
    double iconSize,
    double cardIconSize,
    RideState state,
  ) {
    final isLoading = state is RideLoading;
    double? estimatedPrice;

    if (state is PriceEstimated) {
      estimatedPrice = state.estimate.price;
    }

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: spacing * 0.5, bottom: spacing),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Ride Options
              ...List.generate(_rideOptions.length, (index) {
                final ride = _rideOptions[index];
                final isSelected = _selectedRideIndex == index;
                final displayPrice = estimatedPrice ?? ride['price'] as double? ?? 0.0;
                
                return Padding(
                  padding: EdgeInsets.only(bottom: spacing),
                  child: _buildRideOptionCard(
                    ride,
                    isSelected,
                    displayPrice,
                    titleFontSize,
                    priceFontSize,
                    borderRadius,
                    spacing,
                    cardIconSize,
                    isLoading,
                    () => _onRideSelected(index),
                  ),
                );
              }),
              SizedBox(height: spacing),
              Divider(color: Colors.grey[300]),
              SizedBox(height: spacing),
              // Payment Method
              InkWell(
                onTap: isLoading
                    ? null
                    : () async {
                        final selectedPayment = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const PaymentMethodPage(),
                        );
                        if (selectedPayment != null) {
                          setState(() {
                            _selectedPayment = selectedPayment;
                          });
                        }
                      },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing * 0.5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.payment,
                        color: Colors.grey[600],
                        size: iconSize,
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment Method',
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF212121),
                              ),
                            ),
                            SizedBox(height: spacing * 0.25),
                            Text(
                              _selectedPayment != null
                                  ? _selectedPayment!['name'] as String
                                  : 'Select payment method',
                              style: TextStyle(
                                fontSize: titleFontSize * 0.85,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                        size: iconSize,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing),
              Divider(color: Colors.grey[300]),
              SizedBox(height: spacing),
              // Schedule Ride
              InkWell(
                onTap: isLoading
                    ? null
                    : () async {
                        final scheduled = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => ScheduleRidePage(
                            destination: widget.destination,
                            pickupLocation: widget.pickupLocation,
                            selectedRide: _rideOptions[_selectedRideIndex],
                          ),
                        );
                        if (scheduled != null && scheduled is DateTime) {
                          setState(() {
                            _scheduledDateTime = scheduled;
                          });
                        }
                      },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing * 0.5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.grey[600],
                        size: iconSize,
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: Text(
                          _scheduledDateTime != null
                              ? '${_formatScheduleDate(_scheduledDateTime!)} at ${_formatScheduleTime(_scheduledDateTime!)}'
                              : 'Schedule for later',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w500,
                            color: _scheduledDateTime != null
                                ? const Color(0xFF4CAF50)
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                      if (_scheduledDateTime != null)
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey[400],
                            size: iconSize * 0.8,
                          ),
                          onPressed: () {
                            setState(() {
                              _scheduledDateTime = null;
                            });
                          },
                        ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                        size: iconSize,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing * 1.5),
              // Book Ride Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (estimatedPrice != null && !isLoading)
                      ? _bookRide
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: buttonPadding),
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Book Ride',
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
    );
  }

  Widget _buildRideOptionCard(
    Map<String, dynamic> ride,
    bool isSelected,
    double price,
    double titleFontSize,
    double priceFontSize,
    double borderRadius,
    double spacing,
    double cardIconSize,
    bool isLoading,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[50] : Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4CAF50)
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: cardIconSize,
              height: cardIconSize,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4CAF50).withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Icon(
                ride['icon'] as IconData,
                color: isSelected
                    ? const Color(0xFF4CAF50)
                    : Colors.grey[600],
                size: cardIconSize * 0.5,
              ),
            ),
            SizedBox(width: spacing),
            // Ride Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        ride['name'] as String,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      if (ride['isXL'] == true || ride['isPlus'] == true) ...[
                        SizedBox(width: spacing * 0.5),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing * 0.5,
                            vertical: spacing * 0.25,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            ride['isXL'] == true ? 'XL' : 'PLUS',
                            style: TextStyle(
                              fontSize: titleFontSize * 0.7,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: spacing * 0.25),
                  Text(
                    '${ride['arrival'] as String} • ${ride['passengers'] as String}',
                    style: TextStyle(
                      fontSize: titleFontSize * 0.85,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Price
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: priceFontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF212121),
              ),
            ),
            SizedBox(width: spacing * 0.5),
            // Radio Button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF4CAF50)
                      : Colors.grey[400]!,
                  width: 2,
                ),
                color: isSelected
                    ? const Color(0xFF4CAF50)
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

