import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/injections/injection_container.dart';
import '../bloc/rating_bloc.dart';
import '../bloc/rating_event.dart';
import '../bloc/rating_state.dart';
import '../../../../feedback_confirmation_screen.dart';

class DriverRatingPage extends StatefulWidget {
  final Map<String, dynamic> driver;
  final Map<String, dynamic> selectedRide;
  final Map<String, dynamic>? selectedPayment;
  final Map<String, dynamic>? selectedPromo;
  final int? rideId; // Backend ride ID

  const DriverRatingPage({
    super.key,
    required this.driver,
    required this.selectedRide,
    this.selectedPayment,
    this.selectedPromo,
    this.rideId,
  });

  @override
  State<DriverRatingPage> createState() => _DriverRatingPageState();
}

class _DriverRatingPageState extends State<DriverRatingPage> {
  int _selectedRating = 0;
  bool _showDetails = true;

  double get _tripFare {
    final price = widget.selectedRide['price'];
    if (price is double) return price;
    if (price is String) return double.parse(price.replaceAll('\$', '').replaceAll(',', ''));
    if (price is int) return price.toDouble();
    return 0.0;
  }

  double get _discountAmount {
    if (widget.selectedPromo != null) {
      final title = widget.selectedPromo!['title'] as String;
      final match = RegExp(r'(\d+)%').firstMatch(title);
      if (match != null) {
        final discountPercent = double.parse(match.group(1)!);
        return _tripFare * (discountPercent / 100);
      }
    }
    return _tripFare * 0.20;
  }

  double get _totalPaid => _tripFare - _discountAmount;

  String get _paymentMethod => widget.selectedPayment?['name'] ?? 'GoRide Wallet';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final subtitleFontSize = clampDouble(size.width * 0.038, 13, 15);
    final detailLabelFontSize = clampDouble(size.width * 0.038, 13, 15);
    final detailValueFontSize = clampDouble(size.width * 0.038, 13, 15);
    final totalFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final cardPadding = clampDouble(size.width * 0.04, 12, 16);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final profileSize = clampDouble(size.width * 0.25, 100, 140);
    final starSize = clampDouble(size.width * 0.08, 32, 48);

    return BlocProvider(
      create: (_) => sl<RatingBloc>(),
      child: BlocListener<RatingBloc, RatingState>(
        listener: (context, state) {
          if (state is RideRated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const FeedbackConfirmationScreen(),
              ),
            );
          } else if (state is RatingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: spacing),
                    // Close Button
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black87),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(height: spacing),
                    // Driver Profile Picture
                    Container(
                      width: profileSize,
                      height: profileSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple[200],
                        border: Border.all(color: Colors.purple[300]!, width: 3),
                      ),
                      child: ClipOval(
                        child: Container(
                          color: Colors.purple[200],
                          child: const Icon(Icons.person, color: Colors.purple, size: 80),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing * 1.5),
                    // Title
                    Text(
                      'How was the driver?',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacing * 0.5),
                    // Subtitle
                    Text(
                      'Help GoRide do better by rating this trip',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacing * 1.5),
                    // Star Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRating = index + 1;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: clampDouble(size.width * 0.02, 4, 8),
                            ),
                            child: Icon(
                              index < _selectedRating ? Icons.star : Icons.star_border,
                              size: starSize,
                              color: index < _selectedRating ? Colors.amber : Colors.grey[400],
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: spacing * 2),
                    // Ride and Payment Details
                    _buildDetailsCard(
                      size,
                      clampDouble,
                      detailLabelFontSize,
                      detailValueFontSize,
                      totalFontSize,
                      spacing,
                      cardPadding,
                      borderRadius,
                    ),
                    SizedBox(height: spacing * 2),
                    // Give Rate Button
                    BlocBuilder<RatingBloc, RatingState>(
                      builder: (context, state) {
                        final isLoading = state is RatingLoading;
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (_selectedRating == 0 || isLoading) ? null : _onGiveRate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              padding: EdgeInsets.symmetric(
                                vertical: clampDouble(size.height * 0.02, 14, 18),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(borderRadius),
                              ),
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
                                    'Give Rate',
                                    style: TextStyle(
                                      fontSize: buttonFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: spacing),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onGiveRate() {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.rideId != null) {
      context.read<RatingBloc>().add(RateRideEvent(
            rideId: widget.rideId!,
            rating: _selectedRating,
          ));
    } else {
      // Fallback: navigate anyway if no ride ID
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const FeedbackConfirmationScreen(),
        ),
      );
    }
  }

  Widget _buildDetailsCard(Size size, Function clampDouble, double labelFontSize, double valueFontSize, double totalFontSize, double spacing, double cardPadding, double borderRadius) {
    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: () {
              setState(() {
                _showDetails = !_showDetails;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ride and Payment Details',
                  style: TextStyle(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
                Icon(
                  _showDetails ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
          if (_showDetails) ...[
            SizedBox(height: spacing),
            Divider(color: Colors.grey[300], height: 1),
            SizedBox(height: spacing),
            // Pickup
            _buildDetailRow('Pickup', widget.selectedRide['pickup'] ?? 'N/A', labelFontSize, valueFontSize),
            SizedBox(height: spacing * 0.75),
            // Dropoff
            _buildDetailRow('Dropoff', widget.selectedRide['destination'] ?? 'N/A', labelFontSize, valueFontSize),
            SizedBox(height: spacing * 0.75),
            // Payment Method
            _buildDetailRow('Payment', _paymentMethod, labelFontSize, valueFontSize),
            SizedBox(height: spacing),
            Divider(color: Colors.grey[300], height: 1),
            SizedBox(height: spacing),
            // Fare Breakdown
            _buildDetailRow('Trip Fare', '\$${_tripFare.toStringAsFixed(2)}', labelFontSize, valueFontSize),
            SizedBox(height: spacing * 0.75),
            _buildDetailRow('Discount', '-\$${_discountAmount.toStringAsFixed(2)}', labelFontSize, valueFontSize, isDiscount: true),
            SizedBox(height: spacing),
            Divider(color: Colors.grey[300], height: 1),
            SizedBox(height: spacing),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Paid',
                  style: TextStyle(
                    fontSize: totalFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
                Text(
                  '\$${_totalPaid.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: totalFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double labelFontSize, double valueFontSize, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: valueFontSize,
            fontWeight: FontWeight.w600,
            color: isDiscount ? Colors.green : const Color(0xFF212121),
          ),
        ),
      ],
    );
  }
}

