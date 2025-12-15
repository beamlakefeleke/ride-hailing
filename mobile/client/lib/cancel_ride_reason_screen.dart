import 'package:flutter/material.dart';
import 'ride_cancellation_confirmation_screen.dart';

class CancelRideReasonScreen extends StatefulWidget {
  const CancelRideReasonScreen({super.key});

  @override
  State<CancelRideReasonScreen> createState() => _CancelRideReasonScreenState();
}

class _CancelRideReasonScreenState extends State<CancelRideReasonScreen> {
  int? _selectedReasonIndex = 0; // Default to "Change in plans"

  final List<String> _cancellationReasons = [
    'Change in plans',
    'Waiting for long time',
    'Unable to contact driver',
    'Driver denied to go to destination',
    'Driver denied to come to pickup',
    'Wrong address shown',
    'The price is not reasonable',
    'Emergency situation',
    'Booking mistake',
    'Poor weather conditions',
    'Other',
  ];

  void _onConfirm() {
    if (_selectedReasonIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a reason'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to cancellation confirmation screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const RideCancellationConfirmationScreen(),
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
    final questionFontSize = clampDouble(size.width * 0.042, 14, 16);
    final reasonFontSize = clampDouble(size.width * 0.038, 13, 15);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final radioSize = clampDouble(size.width * 0.06, 22, 28);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Close Button
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cancel Ride',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
              ),
            ),
            SizedBox(height: spacing),
            // Question
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Why are you cancelling?',
                  style: TextStyle(
                    fontSize: questionFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
              ),
            ),
            SizedBox(height: spacing * 1.5),
            // Reasons List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                itemCount: _cancellationReasons.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedReasonIndex == index;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedReasonIndex = index;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
                      child: Row(
                        children: [
                          // Radio Button
                          Container(
                            width: radioSize,
                            height: radioSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? const Color(0xFF4CAF50)
                                  : Colors.white,
                              border: Border.all(
                                color: const Color(0xFF4CAF50),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                          SizedBox(width: spacing),
                          // Reason Text
                          Expanded(
                            child: Text(
                              _cancellationReasons[index],
                              style: TextStyle(
                                fontSize: reasonFontSize,
                                color: const Color(0xFF212121),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Confirm Button
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onConfirm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: clampDouble(size.height * 0.022, 16, 20),
                    ),
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: spacing),
          ],
        ),
      ),
    );
  }
}

