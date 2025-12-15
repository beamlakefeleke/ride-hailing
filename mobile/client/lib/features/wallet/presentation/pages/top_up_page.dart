import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/account/presentation/bloc/account_bloc.dart';
import '../../../../features/account/presentation/bloc/account_event.dart';
import '../../../../features/account/presentation/bloc/account_state.dart';
import 'choose_top_up_method_page.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  String _amount = '250.00';
  double? _availableBalance;
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

  @override
  void initState() {
    super.initState();
    // Get current balance from account
    context.read<AccountBloc>().add(const GetProfileEvent());
    _startCursorBlink();
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

  void _onNumberPressed(String number) {
    setState(() {
      if (_amount == '0.00' || _amount.isEmpty) {
        _amount = '$number.00';
      } else {
        String amountWithoutDecimal = _amount.replaceAll('.', '');
        if (amountWithoutDecimal.length < 6) {
          amountWithoutDecimal += number;
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
          builder: (_) => ChooseTopUpMethodPage(amount: amount),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final amountFontSize = clampDouble(size.width * 0.12, 48, 64);
    final balanceFontSize = clampDouble(size.width * 0.035, 12, 14);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final presetFontSize = clampDouble(size.width * 0.038, 13, 15);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);

    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          setState(() {
            _availableBalance = state.user.walletBalance;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              children: [
                SizedBox(height: spacing * 2),
                // Amount Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        width: 4,
                        height: amountFontSize * 0.6,
                        margin: const EdgeInsets.only(left: 4, top: 8),
                        color: const Color(0xFF4CAF50),
                      ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: EdgeInsets.only(top: amountFontSize * 0.2),
                      child: Text(
                        '\$',
                        style: TextStyle(
                          fontSize: amountFontSize * 0.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing * 0.5),
                // Available Balance
                if (_availableBalance != null)
                  Text(
                    'Available balance: \$${_availableBalance!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: balanceFontSize,
                      color: Colors.grey[600],
                    ),
                  ),
                SizedBox(height: spacing * 2),
                // Preset Amount Buttons
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: _presetAmounts.length,
                  itemBuilder: (context, index) {
                    return _buildPresetButton(
                      _presetAmounts[index],
                      presetFontSize,
                      borderRadius,
                    );
                  },
                ),
                SizedBox(height: spacing * 2),
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: double.parse(_amount) > 0 ? _onContinue : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: EdgeInsets.symmetric(
                        vertical: clampDouble(size.height * 0.02, 14, 18),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing * 2),
                // Numeric Keypad
                _buildKeypad(size, clampDouble, borderRadius),
                SizedBox(height: spacing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPresetButton(String amount, double fontSize, double borderRadius) {
    return OutlinedButton(
      onPressed: () => _onPresetAmountPressed(amount),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
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
    );
  }

  Widget _buildKeypad(Size size, Function clampDouble, double borderRadius) {
    final buttonSize = clampDouble(size.width * 0.2, 60, 80);
    final fontSize = clampDouble(size.width * 0.05, 18, 24);

    return Container(
      padding: EdgeInsets.all(clampDouble(size.width * 0.02, 8, 12)),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['1', '2', '3'].map((num) => _buildKeypadButton(num, buttonSize, fontSize, borderRadius)).toList(),
          ),
          SizedBox(height: clampDouble(size.height * 0.01, 8, 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['4', '5', '6'].map((num) => _buildKeypadButton(num, buttonSize, fontSize, borderRadius)).toList(),
          ),
          SizedBox(height: clampDouble(size.height * 0.01, 8, 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['7', '8', '9'].map((num) => _buildKeypadButton(num, buttonSize, fontSize, borderRadius)).toList(),
          ),
          SizedBox(height: clampDouble(size.height * 0.01, 8, 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('*', buttonSize, fontSize, borderRadius),
              _buildKeypadButton('0', buttonSize, fontSize, borderRadius),
              _buildKeypadButton('⌫', buttonSize, fontSize, borderRadius, isBackspace: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(String label, double size, double fontSize, double borderRadius, {bool isBackspace = false}) {
    return GestureDetector(
      onTap: isBackspace ? _onBackspacePressed : () => _onNumberPressed(label),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius * 0.75),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: isBackspace
              ? Icon(Icons.backspace, size: fontSize * 0.8, color: Colors.grey[700])
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
        ),
      ),
    );
  }
}

