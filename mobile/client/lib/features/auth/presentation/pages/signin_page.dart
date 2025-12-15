import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../config/injections/injection_container.dart';
import 'otp_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _rememberMe = false;
  String _selectedCountryCode = '+1';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required Widget icon,
    required String text,
    required double textSize,
    required double spacing,
    required VoidCallback onPressed,
  }) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();
    final verticalPadding = clampDouble(size.height * 0.02, 12, 18);

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          side: BorderSide(
            color: Colors.grey[300]!,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(width: spacing),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF212121),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleIcon(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: GoogleIconPainter(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is OtpSent) {
              // Navigate to OTP screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OtpPage(
                    phoneNumber: _phoneController.text,
                    countryCode: _selectedCountryCode,
                    isSignUp: false,
                  ),
                ),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return _buildContent(context, isLoading);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
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
    final labelFontSize = clampDouble(size.width * 0.04, 14, 18);
    final socialFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonPadding = clampDouble(size.height * 0.022, 14, 20);
    final dividerFontSize = clampDouble(size.width * 0.035, 12, 14);
    final iconSize = clampDouble(size.width * 0.06, 22, 30);
    final checkboxSize = clampDouble(size.width * 0.065, 20, 26);
    final borderRadius = clampDouble(size.width * 0.04, 10, 14);
    final spacingBetweenIconAndText = clampDouble(size.width * 0.03, 8, 16);
    final emojiSize = clampDouble(size.width * 0.05, 20, 28);

    return SafeArea(
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
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(height: tinyGap),
                    // Title with waving hand emoji
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF212121),
                              height: 1.2,
                            ),
                          ),
                        ),
                        Text(
                          '👋',
                          style: TextStyle(fontSize: emojiSize),
                        ),
                      ],
                    ),
                    SizedBox(height: smallGap),
                    // Subtitle
                    Text(
                      'Please enter your phone number to sign in to your GoRide account.',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: largeGap),
                    // Phone Number Label
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: smallGap),
                    // Phone Number Input Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Country Code Selector
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacingBetweenIconAndText,
                              vertical: spacingBetweenIconAndText / 2,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: iconSize,
                                  height: iconSize,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.blue[900],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '🇺🇸',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                SizedBox(width: spacingBetweenIconAndText / 1.5),
                                DropdownButton<String>(
                                  value: _selectedCountryCode,
                                  underline: const SizedBox(),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey[600],
                                    size: iconSize,
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: '+1', child: Text('+1')),
                                    DropdownMenuItem(value: '+44', child: Text('+44')),
                                    DropdownMenuItem(value: '+91', child: Text('+91')),
                                  ],
                                  onChanged: isLoading
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _selectedCountryCode = value!;
                                          });
                                        },
                                ),
                              ],
                            ),
                          ),
                          // Phone Number Input
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              enabled: !isLoading,
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: spacingBetweenIconAndText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: mediumGap),
                    // Remember Me Checkbox
                    Row(
                      children: [
                        SizedBox(
                          width: checkboxSize,
                          height: checkboxSize,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                            activeColor: const Color(0xFF4CAF50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: const BorderSide(
                              color: Color(0xFF4CAF50),
                              width: 2,
                            ),
                          ),
                        ),
                        SizedBox(width: spacingBetweenIconAndText),
                        Text(
                          'Remember me',
                          style: TextStyle(
                            fontSize: labelFontSize,
                            color: const Color(0xFF212121),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: largeGap),
                    // Separator with "or"
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: TextStyle(
                              fontSize: dividerFontSize,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: largeGap),
                    // Social Login Buttons
                    _buildSocialButton(
                      context: context,
                      icon: _buildGoogleIcon(iconSize),
                      text: 'Continue with Google',
                      textSize: socialFontSize,
                      spacing: spacingBetweenIconAndText,
                      onPressed: () {
                        // Handle Google login
                      },
                    ),
                    SizedBox(height: mediumGap),
                    _buildSocialButton(
                      context: context,
                      icon: Icon(
                        Icons.apple,
                        color: Colors.black,
                        size: iconSize,
                      ),
                      text: 'Continue with Apple',
                      textSize: socialFontSize,
                      spacing: spacingBetweenIconAndText,
                      onPressed: () {
                        // Handle Apple login
                      },
                    ),
                    SizedBox(height: mediumGap),
                    _buildSocialButton(
                      context: context,
                      icon: Container(
                        width: iconSize,
                        height: iconSize,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1877F2),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'f',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      text: 'Continue with Facebook',
                      textSize: socialFontSize,
                      spacing: spacingBetweenIconAndText,
                      onPressed: () {
                        // Handle Facebook login
                      },
                    ),
                    SizedBox(height: mediumGap),
                    _buildSocialButton(
                      context: context,
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: iconSize,
                      ),
                      text: 'Continue with X',
                      textSize: socialFontSize,
                      spacing: spacingBetweenIconAndText,
                      onPressed: () {
                        // Handle X (Twitter) login
                      },
                    ),
                    SizedBox(height: largeGap),
                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (_phoneController.text.isNotEmpty && !isLoading)
                            ? () {
                                context.read<AuthBloc>().add(
                                      SendOtpEvent(
                                        phoneNumber: _phoneController.text,
                                        countryCode: _selectedCountryCode,
                                      ),
                                    );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: buttonPadding),
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: socialFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: largeGap),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom painter for Google icon
class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Blue section
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -1.57, // -90 degrees
      1.57, // 90 degrees
      true,
      paint,
    );

    // Red section
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0, // 0 degrees
      1.57, // 90 degrees
      true,
      paint,
    );

    // Yellow section
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      1.57, // 90 degrees
      1.57, // 90 degrees
      true,
      paint,
    );

    // Green section
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      3.14, // 180 degrees
      1.57, // 90 degrees
      true,
      paint,
    );

    // White center circle
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.35,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
