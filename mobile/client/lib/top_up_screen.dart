import 'package:flutter/material.dart';
import 'choose_top_up_method_screen.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  String _amount = '250.00';
  final double _availableBalance = 2069.50;
  bool _showCursor = true;

  final List<String> _presetAmounts = [
    '5.00',
    '10.00',
    '20.00',
    '25.00',
    '50.00',
    '75.00',
    '100.00',
    '150.00',
    '200.00',
  ];

  void _onNumberPressed(String number) {
    setState(() {
      if (_amount == '0.00' || _amount.isEmpty) {
        _amount = '$number.00';
      } else {
        // Remove decimal and add number
        String amountWithoutDecimal = _amount.replaceAll('.', '');
        if (amountWithoutDecimal.length < 6) { // Limit to reasonable amount
          amountWithoutDecimal += number;
          // Reformat with decimal
          if (amountWithoutDecimal.length >= 2) {
            String dollars = amountWithoutDecimal.substring(0, amountWithoutDecimal.length - 2);
            String cents = amountWithoutDecimal.substring(amountWithoutDecimal.length - 2);
            _amount = '$dollars.$cents';
          } else {
            _amount = '0.$amountWithoutDecimal';
          }
        }
      }
      _showCursor = true;
    });
  }

  void _onBackspacePressed() {
    setState(() {
      if (_amount.length > 1) {
        String amountWithoutDecimal = _amount.replaceAll('.', '');
        amountWithoutDecimal = amountWithoutDecimal.substring(0, amountWithoutDecimal.length - 1);
        if (amountWithoutDecimal.isEmpty) {
          _amount = '0.00';
        } else if (amountWithoutDecimal.length == 1) {
          _amount = '0.0$amountWithoutDecimal';
        } else {
          String dollars = amountWithoutDecimal.substring(0, amountWithoutDecimal.length - 2);
          String cents = amountWithoutDecimal.substring(amountWithoutDecimal.length - 2);
          _amount = '$dollars.$cents';
        }
      } else {
        _amount = '0.00';
      }
      _showCursor = true;
    });
  }

  void _onPresetAmountPressed(String amount) {
    setState(() {
      _amount = amount;
      _showCursor = true;
    });
  }

  void _onContinue() {
    final amount = double.parse(_amount);
    if (amount > 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChooseTopUpMethodScreen(amount: amount),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Blink cursor
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showCursor = !_showCursor;
        });
        _startCursorBlink();
      }
    });
  }

  void _startCursorBlink() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showCursor = !_showCursor;
        });
        _startCursorBlink();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final amountFontSize = clampDouble(size.width * 0.15, 48, 64);
    final balanceFontSize = clampDouble(size.width * 0.035, 12, 14);
    final presetButtonFontSize = clampDouble(size.width * 0.038, 13, 15);
    final keypadFontSize = clampDouble(size.width * 0.055, 20, 24);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, size, clampDouble, titleFontSize),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: spacing * 2),
                    // Amount Input Area
                    _buildAmountInputArea(
                      size,
                      clampDouble,
                      amountFontSize,
                      balanceFontSize,
                      spacing,
                      borderRadius,
                    ),
                    SizedBox(height: spacing * 2),
                    // Preset Amount Buttons
                    _buildPresetAmountButtons(
                      size,
                      clampDouble,
                      presetButtonFontSize,
                      spacing,
                      borderRadius,
                    ),
                    SizedBox(height: spacing * 2),
                    // Continue Button
                    _buildContinueButton(
                      size,
                      clampDouble,
                      buttonFontSize,
                      spacing,
                      borderRadius,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Numeric Keypad
          _buildNumericKeypad(
            size,
            clampDouble,
            keypadFontSize,
            spacing,
            borderRadius,
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
        'Top Up',
        style: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF212121),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildAmountInputArea(
    Size size,
    Function clampDouble,
    double amountFontSize,
    double balanceFontSize,
    double spacing,
    double borderRadius,
  ) {
    return Container(
      padding: EdgeInsets.all(clampDouble(size.width * 0.06, 20, 28)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount Display
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _amount,
                style: TextStyle(
                  fontSize: amountFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
              if (_showCursor)
                Container(
                  width: 3,
                  height: amountFontSize * 0.6,
                  margin: const EdgeInsets.only(left: 4),
                  color: const Color(0xFF4CAF50),
                ),
              const SizedBox(width: 8),
              Text(
                '\$',
                style: TextStyle(
                  fontSize: amountFontSize * 0.6,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          // Available Balance
          Text(
            'Available balance: \$${_availableBalance.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: balanceFontSize,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetAmountButtons(
    Size size,
    Function clampDouble,
    double fontSize,
    double spacing,
    double borderRadius,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: spacing * 0.75,
          runSpacing: spacing * 0.75,
          children: _presetAmounts.map((amount) {
            return GestureDetector(
              onTap: () => _onPresetAmountPressed(amount),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: clampDouble(size.width * 0.06, 20, 28),
                  vertical: spacing * 0.75,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius * 2),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Text(
                  '\$$amount',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContinueButton(
    Size size,
    Function clampDouble,
    double fontSize,
    double spacing,
    double borderRadius,
  ) {
    final amount = double.parse(_amount);
    final isEnabled = amount > 0;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          disabledBackgroundColor: Colors.grey[300],
          padding: EdgeInsets.symmetric(
            vertical: clampDouble(size.height * 0.02, 14, 18),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
        child: Text(
          'Continue',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildNumericKeypad(
    Size size,
    Function clampDouble,
    double fontSize,
    double spacing,
    double borderRadius,
  ) {
    return Container(
      padding: EdgeInsets.all(clampDouble(size.width * 0.03, 10, 16)),
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: Column(
        children: [
          // Row 1: 1, 2, 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('1', fontSize, spacing, borderRadius),
              _buildKeypadButton('2', fontSize, spacing, borderRadius),
              _buildKeypadButton('3', fontSize, spacing, borderRadius),
            ],
          ),
          SizedBox(height: spacing * 0.5),
          // Row 2: 4, 5, 6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('4', fontSize, spacing, borderRadius),
              _buildKeypadButton('5', fontSize, spacing, borderRadius),
              _buildKeypadButton('6', fontSize, spacing, borderRadius),
            ],
          ),
          SizedBox(height: spacing * 0.5),
          // Row 3: 7, 8, 9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('7', fontSize, spacing, borderRadius),
              _buildKeypadButton('8', fontSize, spacing, borderRadius),
              _buildKeypadButton('9', fontSize, spacing, borderRadius),
            ],
          ),
          SizedBox(height: spacing * 0.5),
          // Row 4: *, 0, backspace
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('*', fontSize, spacing, borderRadius, isDisabled: true),
              _buildKeypadButton('0', fontSize, spacing, borderRadius),
              _buildKeypadButton('', fontSize, spacing, borderRadius, isBackspace: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(
    String text,
    double fontSize,
    double spacing,
    double borderRadius, {
    bool isDisabled = false,
    bool isBackspace = false,
  }) {
    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              if (isBackspace) {
                _onBackspacePressed();
              } else {
                _onNumberPressed(text);
              }
            },
      child: Container(
        width: fontSize * 2.5,
        height: fontSize * 2.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius * 0.75),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Center(
          child: isBackspace
              ? Icon(
                  Icons.backspace,
                  size: fontSize * 0.8,
                  color: Colors.grey[700],
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: isDisabled ? Colors.grey[400] : const Color(0xFF212121),
                  ),
                ),
        ),
      ),
    );
  }
}

