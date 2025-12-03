import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_page.dart';

class ProfileCompletionScreen extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;

  const ProfileCompletionScreen({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  State<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;
  String _selectedCountryCode = '+1';

  final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.countryCode;
    _phoneController.text = widget.phoneNumber;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  void _onContinue() {
    if (_fullNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _selectedGender != null &&
        _selectedDate != null) {
      // Navigate to home page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const MyHomePage(title: 'GoRide'),
        ),
      );
    }
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
    final labelFontSize = clampDouble(size.width * 0.04, 14, 18);
    final inputFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonPadding = clampDouble(size.height * 0.022, 14, 20);
    final borderRadius = clampDouble(size.width * 0.04, 10, 14);
    final spacingBetweenIconAndText = clampDouble(size.width * 0.03, 8, 16);
    final iconSize = clampDouble(size.width * 0.06, 22, 30);
    final avatarSize = clampDouble(size.width * 0.3, 100, 140);
    final editIconSize = clampDouble(size.width * 0.08, 32, 48);

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
                      // Title
                      Center(
                        child: Text(
                          'Fill Personal Info',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF212121),
                            height: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: largeGap),
                      // Profile Avatar Section
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: avatarSize,
                              height: avatarSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                size: avatarSize * 0.6,
                                color: Colors.grey[400],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: editIconSize,
                                height: editIconSize,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: editIconSize * 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: largeGap),
                      // Full Name Field
                      Text(
                        'Full Name',
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      SizedBox(height: smallGap),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: _fullNameController,
                          style: TextStyle(
                            fontSize: inputFontSize,
                            color: const Color(0xFF212121),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Full Name',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: spacingBetweenIconAndText,
                              vertical: spacingBetweenIconAndText,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: mediumGap),
                      // Email Field
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      SizedBox(height: smallGap),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: inputFontSize,
                            color: const Color(0xFF212121),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.grey[600],
                              size: iconSize * 0.7,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: spacingBetweenIconAndText,
                              vertical: spacingBetweenIconAndText,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: mediumGap),
                      // Phone Number Field
                      Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      SizedBox(height: smallGap),
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
                                      DropdownMenuItem(
                                        value: '+1',
                                        child: Text('+1'),
                                      ),
                                      DropdownMenuItem(
                                        value: '+44',
                                        child: Text('+44'),
                                      ),
                                      DropdownMenuItem(
                                        value: '+91',
                                        child: Text('+91'),
                                      ),
                                    ],
                                    onChanged: (value) {
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
                                style: TextStyle(
                                  fontSize: inputFontSize,
                                  color: const Color(0xFF212121),
                                ),
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
                      // Gender Field
                      Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      SizedBox(height: smallGap),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: InputDecoration(
                            hintText: 'Gender',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: spacingBetweenIconAndText,
                              vertical: spacingBetweenIconAndText,
                            ),
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey[600],
                              size: iconSize,
                            ),
                          ),
                          items: _genders.map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(
                                gender,
                                style: TextStyle(
                                  fontSize: inputFontSize,
                                  color: const Color(0xFF212121),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: mediumGap),
                      // Date of Birth Field
                      Text(
                        'Date of Birth',
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      SizedBox(height: smallGap),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: _dateOfBirthController,
                          readOnly: true,
                          style: TextStyle(
                            fontSize: inputFontSize,
                            color: const Color(0xFF212121),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Date of Birth',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: spacingBetweenIconAndText,
                              vertical: spacingBetweenIconAndText,
                            ),
                          ),
                          onTap: () => _selectDate(context),
                        ),
                      ),
                      SizedBox(height: largeGap),
                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _fullNameController.text.isNotEmpty &&
                                  _emailController.text.isNotEmpty &&
                                  _phoneController.text.isNotEmpty &&
                                  _selectedGender != null &&
                                  _selectedDate != null
                              ? _onContinue
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
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: buttonFontSize,
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
      ),
    );
  }
}

