import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  String _selectedGender = 'Male';
  DateTime _selectedDate = DateTime(1995, 12, 27);

  @override
  void initState() {
    super.initState();
    _fullNameController.text = 'Andrew Ainsley';
    _emailController.text = 'andrew.ainsley@yourdomain.com';
    _phoneController.text = '+1 (646) 555-4099';
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
      initialDate: _selectedDate,
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
                    _selectedGender = 'Male';
                  });
                  Navigator.of(context).pop();
                },
                trailing: _selectedGender == 'Male'
                    ? const Icon(Icons.check, color: Color(0xFF4CAF50))
                    : null,
              ),
              ListTile(
                title: const Text('Female'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'Female';
                  });
                  Navigator.of(context).pop();
                },
                trailing: _selectedGender == 'Female'
                    ? const Icon(Icons.check, color: Color(0xFF4CAF50))
                    : null,
              ),
              ListTile(
                title: const Text('Other'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'Other';
                  });
                  Navigator.of(context).pop();
                },
                trailing: _selectedGender == 'Other'
                    ? const Icon(Icons.check, color: Color(0xFF4CAF50))
                    : null,
              ),
            ],
          ),
        );
      },
    );
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, size, clampDouble, titleFontSize),
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
        'Personal Info',
        style: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF212121),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProfilePicture(
    Size size,
    Function clampDouble,
    double profileSize,
    double spacing,
    double borderRadius,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Profile Picture
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
        // Edit Icon Overlay
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit profile picture'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              width: clampDouble(size.width * 0.12, 36, 44),
              height: clampDouble(size.width * 0.12, 36, 44),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    Size size,
    Function clampDouble,
    String label,
    TextEditingController controller,
    double labelFontSize,
    double inputFontSize,
    double spacing,
    double borderRadius,
  ) {
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
        TextField(
          controller: controller,
          style: TextStyle(fontSize: inputFontSize),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(
                color: Color(0xFF4CAF50),
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(spacing),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailInput(
    Size size,
    Function clampDouble,
    String label,
    TextEditingController controller,
    double labelFontSize,
    double inputFontSize,
    double spacing,
    double borderRadius,
  ) {
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
        TextField(
          controller: controller,
          style: TextStyle(fontSize: inputFontSize),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            prefixIcon: Icon(
              Icons.email,
              color: Colors.grey[600],
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(
                color: Color(0xFF4CAF50),
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(spacing),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInput(
    Size size,
    Function clampDouble,
    String label,
    TextEditingController controller,
    double labelFontSize,
    double inputFontSize,
    double spacing,
    double borderRadius,
  ) {
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
        TextField(
          controller: controller,
          style: TextStyle(fontSize: inputFontSize),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: spacing),
                // Flag icon (using a simple icon as placeholder)
                Icon(
                  Icons.flag,
                  color: Colors.grey[600],
                  size: 20,
                ),
                SizedBox(width: spacing * 0.5),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                  size: 20,
                ),
                SizedBox(width: spacing * 0.5),
              ],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(
                color: Color(0xFF4CAF50),
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(spacing),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderInput(
    Size size,
    Function clampDouble,
    String label,
    String selectedValue,
    double labelFontSize,
    double inputFontSize,
    double spacing,
    double borderRadius,
  ) {
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
            padding: EdgeInsets.all(spacing),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedValue,
                    style: TextStyle(
                      fontSize: inputFontSize,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateInput(
    Size size,
    Function clampDouble,
    String label,
    DateTime selectedDate,
    double labelFontSize,
    double inputFontSize,
    double spacing,
    double borderRadius,
  ) {
    final dateFormat = DateFormat('MM-dd-yyyy');
    final formattedDate = dateFormat.format(selectedDate);

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
            padding: EdgeInsets.all(spacing),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: inputFontSize,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

