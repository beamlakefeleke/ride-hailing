import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../config/injections/injection_container.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  String? _selectedGender;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Load current profile
    context.read<AccountBloc>().add(const GetProfileEvent());
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50),
              onPrimary: Colors.white,
              onSurface: Color(0xFF212121),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showGenderPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Male'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'MALE';
                  });
                  Navigator.of(context).pop();
                },
                trailing: _selectedGender == 'MALE'
                    ? const Icon(Icons.check, color: Color(0xFF4CAF50))
                    : null,
              ),
              ListTile(
                title: const Text('Female'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'FEMALE';
                  });
                  Navigator.of(context).pop();
                },
                trailing: _selectedGender == 'FEMALE'
                    ? const Icon(Icons.check, color: Color(0xFF4CAF50))
                    : null,
              ),
              ListTile(
                title: const Text('Other'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'OTHER';
                  });
                  Navigator.of(context).pop();
                },
                trailing: _selectedGender == 'OTHER'
                    ? const Icon(Icons.check, color: Color(0xFF4CAF50))
                    : null,
              ),
              ListTile(
                title: const Text('Prefer not to say'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'PREFER_NOT_TO_SAY';
                  });
                  Navigator.of(context).pop();
                },
                trailing: _selectedGender == 'PREFER_NOT_TO_SAY'
                    ? const Icon(Icons.check, color: Color(0xFF4CAF50))
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSave() {
    // Extract phone number and country code
    String? phoneNumber;
    String? countryCode;
    final phoneText = _phoneController.text.trim();
    if (phoneText.isNotEmpty) {
      // Try to extract country code (assuming format like +1 (646) 555-4099)
      final match = RegExp(r'\+(\d+)\s*\((\d+)\)\s*(\d+)-(\d+)').firstMatch(phoneText);
      if (match != null) {
        countryCode = '+${match.group(1)}';
        phoneNumber = '${match.group(2)}${match.group(3)}${match.group(4)}';
      } else {
        // Fallback: assume +1 if no country code
        countryCode = '+1';
        phoneNumber = phoneText.replaceAll(RegExp(r'[^\d]'), '');
      }
    }

    context.read<AccountBloc>().add(UpdateProfileEvent(
      fullName: _fullNameController.text.trim().isEmpty ? null : _fullNameController.text.trim(),
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      gender: _selectedGender,
      dateOfBirth: _selectedDate,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final labelFontSize = clampDouble(size.width * 0.038, 13, 15);
    final inputFontSize = clampDouble(size.width * 0.038, 13, 15);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final profileSize = clampDouble(size.width * 0.3, 100, 140);

    return BlocProvider(
      create: (_) => sl<AccountBloc>()..add(const GetProfileEvent()),
      child: BlocConsumer<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            // Populate fields with current user data
            if (_fullNameController.text.isEmpty) {
              _fullNameController.text = state.user.fullName ?? '';
              _emailController.text = state.user.email ?? '';
              if (state.user.phoneNumber != null) {
                // Format phone number for display
                final phone = state.user.phoneNumber!;
                if (phone.startsWith('+1') && phone.length == 12) {
                  _phoneController.text = '+1 (${phone.substring(2, 5)}) ${phone.substring(5, 8)}-${phone.substring(8)}';
                } else {
                  _phoneController.text = phone;
                }
              }
              _selectedGender = state.user.gender;
              _selectedDate = state.user.dateOfBirth;
            }
          } else if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is AccountError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AccountLoading && _fullNameController.text.isEmpty) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Personal Info',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
              centerTitle: true,
              actions: [
                if (state is AccountLoading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  TextButton(
                    onPressed: _onSave,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: spacing * 2),
                    // Profile Picture
                    _buildProfilePicture(size, clampDouble, profileSize, spacing, borderRadius),
                    SizedBox(height: spacing * 2),
                    // Full Name Input
                    _buildInputField(
                      size,
                      clampDouble,
                      'Full Name',
                      _fullNameController,
                      labelFontSize,
                      inputFontSize,
                      spacing,
                      borderRadius,
                    ),
                    SizedBox(height: spacing * 1.5),
                    // Email Input
                    _buildEmailInput(
                      size,
                      clampDouble,
                      'Email',
                      _emailController,
                      labelFontSize,
                      inputFontSize,
                      spacing,
                      borderRadius,
                    ),
                    SizedBox(height: spacing * 1.5),
                    // Phone Number Input
                    _buildPhoneInput(
                      size,
                      clampDouble,
                      'Phone Number',
                      _phoneController,
                      labelFontSize,
                      inputFontSize,
                      spacing,
                      borderRadius,
                    ),
                    SizedBox(height: spacing * 1.5),
                    // Gender Input
                    _buildGenderInput(
                      size,
                      clampDouble,
                      'Gender',
                      _selectedGender,
                      labelFontSize,
                      inputFontSize,
                      spacing,
                      borderRadius,
                    ),
                    SizedBox(height: spacing * 1.5),
                    // Date of Birth Input
                    _buildDateInput(
                      size,
                      clampDouble,
                      'Date of Birth',
                      _selectedDate,
                      labelFontSize,
                      inputFontSize,
                      spacing,
                      borderRadius,
                    ),
                    SizedBox(height: spacing * 2),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfilePicture(Size size, Function clampDouble, double profileSize, double spacing, double borderRadius) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: profileSize,
          height: profileSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
            border: Border.all(
              color: Colors.grey[300]!,
              width: 3,
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
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit profile picture feature coming soon'),
                ),
              );
            },
            child: Container(
              width: clampDouble(size.width * 0.12, 36, 44),
              height: clampDouble(size.width * 0.12, 36, 44),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(Size size, Function clampDouble, String label, TextEditingController controller, double labelFontSize, double inputFontSize, double spacing, double borderRadius) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
        ),
        SizedBox(height: spacing * 0.5),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: clampDouble(size.width * 0.04, 12, 16),
            vertical: spacing * 0.75,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(fontSize: inputFontSize),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailInput(Size size, Function clampDouble, String label, TextEditingController controller, double labelFontSize, double inputFontSize, double spacing, double borderRadius) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
        ),
        SizedBox(height: spacing * 0.5),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: clampDouble(size.width * 0.04, 12, 16),
            vertical: spacing * 0.75,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            children: [
              Icon(Icons.email, size: inputFontSize * 1.2, color: Colors.grey[600]),
              SizedBox(width: spacing * 0.5),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: inputFontSize),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInput(Size size, Function clampDouble, String label, TextEditingController controller, double labelFontSize, double inputFontSize, double spacing, double borderRadius) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
        ),
        SizedBox(height: spacing * 0.5),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: clampDouble(size.width * 0.04, 12, 16),
            vertical: spacing * 0.75,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            children: [
              const Text('🇺🇸', style: TextStyle(fontSize: 20)),
              SizedBox(width: spacing * 0.5),
              const Text('+1', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              SizedBox(width: spacing * 0.5),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: inputFontSize),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderInput(Size size, Function clampDouble, String label, String? selectedGender, double labelFontSize, double inputFontSize, double spacing, double borderRadius) {
    String displayGender = 'Select';
    if (selectedGender != null) {
      switch (selectedGender) {
        case 'MALE':
          displayGender = 'Male';
          break;
        case 'FEMALE':
          displayGender = 'Female';
          break;
        case 'OTHER':
          displayGender = 'Other';
          break;
        case 'PREFER_NOT_TO_SAY':
          displayGender = 'Prefer not to say';
          break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
        ),
        SizedBox(height: spacing * 0.5),
        GestureDetector(
          onTap: _showGenderPicker,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: clampDouble(size.width * 0.04, 12, 16),
              vertical: spacing * 0.75,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayGender,
                  style: TextStyle(fontSize: inputFontSize, color: selectedGender != null ? const Color(0xFF212121) : Colors.grey[600]),
                ),
                Icon(Icons.chevron_right, size: inputFontSize * 1.2, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateInput(Size size, Function clampDouble, String label, DateTime? selectedDate, double labelFontSize, double inputFontSize, double spacing, double borderRadius) {
    String displayDate = 'Select';
    if (selectedDate != null) {
      displayDate = DateFormat('MM-dd-yyyy').format(selectedDate);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
        ),
        SizedBox(height: spacing * 0.5),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: clampDouble(size.width * 0.04, 12, 16),
              vertical: spacing * 0.75,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayDate,
                  style: TextStyle(fontSize: inputFontSize, color: selectedDate != null ? const Color(0xFF212121) : Colors.grey[600]),
                ),
                Icon(Icons.calendar_today, size: inputFontSize * 1.2, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

