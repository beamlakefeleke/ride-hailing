import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import 'profile_completion_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;
  final bool isSignUp;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
    this.isSignUp = false,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  int _resendTimer = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = 60;
    _canResend = false;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      
      setState(() {
        _resendTimer--;
        if (_resendTimer <= 0) {
          _canResend = true;
        }
      });
      
      return _resendTimer > 0;
    });
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1) {
      // Move to next field
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field, verify OTP
        _verifyOtp();
      }
    } else if (value.isEmpty && index > 0) {
      // Move to previous field on backspace
      _focusNodes[index - 1].requestFocus();
    }
  }


  void _verifyOtp() {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length == 4) {
      // Navigate based on flow
      if (widget.isSignUp) {
        // Navigate to profile completion for sign up
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ProfileCompletionScreen(
              phoneNumber: widget.phoneNumber,
              countryCode: widget.countryCode,
            ),
          ),
        );
      } else {
        // Navigate to home page for sign in
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MyHomePage(title: 'GoRide'),
          ),
        );
      }
    }
  }

  void _resendCode() {
    if (_canResend) {
      _startResendTimer();
      // Handle resend code logic here
    }
  }

  String _formatPhoneNumber() {
    final phone = widget.phoneNumber;
    if (phone.length == 10) {
      return '(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.08, 16, 28);
    final maxContentWidth = clampDouble(size.width * 0.9, 320, 520);
    final topPadding = clampDouble(size.height * 0.02, 12, 28);
    final largeGap = clampDouble(size.height * 0.04, 20, 36);
    final mediumGap = clampDouble(size.height * 0.03, 16, 28);
    final smallGap = clampDouble(size.height * 0.02, 12, 22);
    final tinyGap = clampDouble(size.height * 0.015, 8, 16);

    final titleFontSize = clampDouble(size.width * 0.072, 22, 30);
    final subtitleFontSize = clampDouble(size.width * 0.042, 14, 18);
    final otpBoxSize = clampDouble(size.width * 0.15, 60, 80);
    final otpFontSize = clampDouble(size.width * 0.08, 24, 32);
    final resendFontSize = clampDouble(size.width * 0.038, 13, 16);
    final iconSize = clampDouble(size.width * 0.05, 18, 24);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: topPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Arrow
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      SizedBox(height: tinyGap),
                      // Title with padlock icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Enter OTP Code',
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF212121),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(width: smallGap / 2),
                          Icon(
                            Icons.lock,
                            color: Colors.amber[700],
                            size: iconSize,
                          ),
                        ],
                      ),
                      SizedBox(height: smallGap),
                      // Instructions
                      Text(
                        'Check your messages! We\'ve sent a one-time code to ${widget.countryCode} (${_formatPhoneNumber()}). Enter the code below to verify your account and continue.',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: largeGap),
                      // OTP Input Fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          return Container(
                            width: otpBoxSize,
                            height: otpBoxSize,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _focusNodes[index].hasFocus
                                    ? const Color(0xFF4CAF50)
                                    : Colors.grey[300]!,
                                width: _focusNodes[index].hasFocus ? 2 : 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: otpFontSize,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF212121),
                              ),
                              maxLength: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (value) => _onOtpChanged(index, value),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: mediumGap),
                      // Resend Code Section
                      Column(
                        children: [
                          if (!_canResend)
                            Text(
                              'You can resend the code in $_resendTimer seconds',
                              style: TextStyle(
                                fontSize: resendFontSize,
                                color: Colors.grey[600],
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                          SizedBox(height: tinyGap),
                          GestureDetector(
                            onTap: _canResend ? _resendCode : null,
                            child: Text(
                              'Resend code',
                              style: TextStyle(
                                fontSize: resendFontSize,
                                color: _canResend
                                    ? const Color(0xFF4CAF50)
                                    : Colors.grey[400],
                                fontWeight: FontWeight.w600,
                                decoration: _canResend
                                    ? TextDecoration.underline
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: largeGap),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

