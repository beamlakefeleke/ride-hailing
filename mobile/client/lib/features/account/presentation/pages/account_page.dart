import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/injections/injection_container.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';
import '../../../location/presentation/pages/saved_addresses_page.dart';
import '../../../wallet/presentation/pages/top_up_page.dart';
import '../pages/personal_info_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AccountBloc>()..add(const GetProfileEvent()),
      child: const _AccountPageView(),
    );
  }
}

class _AccountPageView extends StatelessWidget {
  const _AccountPageView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final cardTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final cardSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final listItemFontSize = clampDouble(size.width * 0.038, 13, 15);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final profileSize = clampDouble(size.width * 0.18, 60, 80);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(size, clampDouble, horizontalPadding, titleFontSize),
      body: BlocConsumer<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is LoggedOut) {
            // Navigate to auth screen
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/auth',
              (route) => false,
            );
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
          if (state is AccountLoading || state is AccountInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: spacing),
                    // Profile and Balance Card
                    _buildProfileCard(
                      size,
                      clampDouble,
                      profileSize,
                      cardTitleFontSize,
                      cardSubtitleFontSize,
                      spacing,
                      borderRadius,
                      context,
                      user,
                    ),
                    SizedBox(height: spacing * 1.5),
                    // Account Settings List
                    _buildAccountSettingsList(
                      size,
                      clampDouble,
                      listItemFontSize,
                      spacing,
                      borderRadius,
                      context,
                    ),
                    SizedBox(height: spacing),
                    // Logout Option
                    _buildLogoutOption(
                      size,
                      clampDouble,
                      listItemFontSize,
                      spacing,
                      borderRadius,
                      context,
                    ),
                    SizedBox(height: spacing * 2),
                  ],
                ),
              ),
            );
          }

          if (state is AccountError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AccountBloc>().add(const GetProfileEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double titleFontSize,
  ) {
    final logoSize = clampDouble(size.width * 0.08, 32, 40);

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(horizontalPadding * 0.5),
        child: Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'Go',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        'Account',
        style: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF212121),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Color(0xFF212121)),
          onPressed: () {
            // Handle menu
          },
        ),
      ],
    );
  }

  Widget _buildProfileCard(
    Size size,
    Function clampDouble,
    double profileSize,
    double titleFontSize,
    double subtitleFontSize,
    double spacing,
    double borderRadius,
    BuildContext context,
    user,
  ) {
    final displayName = user.fullName ?? 'User';
    final phoneNumber = user.phoneNumber ?? 'No phone';
    final walletBalance = user.walletBalance ?? 0.0;

    return Container(
      padding: EdgeInsets.all(clampDouble(size.width * 0.05, 16, 24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Section
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PersonalInfoPage(),
                ),
              );
            },
            child: Row(
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
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: user.profileImageUrl != null
                        ? Image.network(
                            user.profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey[600],
                                  size: profileSize * 0.6,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              color: Colors.grey[600],
                              size: profileSize * 0.6,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: spacing),
                // Name and Phone
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      SizedBox(height: spacing * 0.25),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: subtitleFontSize * 1.2,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: spacing * 0.25),
                          Expanded(
                            child: Text(
                              phoneNumber,
                              style: TextStyle(
                                fontSize: subtitleFontSize,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Chevron Icon
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: subtitleFontSize * 1.5,
                ),
              ],
            ),
          ),
          SizedBox(height: spacing * 1.5),
          Divider(color: Colors.grey[200], height: 1),
          SizedBox(height: spacing * 1.5),
          // Balance Section
          Row(
            children: [
              // Wallet Icon
              Container(
                width: clampDouble(size.width * 0.12, 40, 50),
                height: clampDouble(size.width * 0.12, 40, 50),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(borderRadius * 0.75),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
              ),
              SizedBox(width: spacing),
              // Balance Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${walletBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      'Available balance',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Top Up Button
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TopUpPage(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: clampDouble(size.width * 0.04, 12, 16),
                    vertical: clampDouble(size.height * 0.015, 10, 14),
                  ),
                  side: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius * 0.75),
                  ),
                ),
                child: Text(
                  'Top Up',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettingsList(
    Size size,
    Function clampDouble,
    double fontSize,
    double spacing,
    double borderRadius,
    BuildContext context,
  ) {
    final settings = [
      {
        'title': 'Saved Addresses',
        'icon': Icons.location_on,
        'color': Colors.blue,
        'route': const SavedAddressesPage(),
      },
      {
        'title': 'Notifications',
        'icon': Icons.notifications,
        'color': Colors.orange,
      },
      {
        'title': 'Payment Methods',
        'icon': Icons.credit_card,
        'color': Colors.purple,
      },
      {
        'title': 'Account & Security',
        'icon': Icons.shield,
        'color': Colors.green,
      },
      {
        'title': 'Linked Accounts',
        'icon': Icons.swap_vert,
        'color': Colors.teal,
      },
      {
        'title': 'App Appearance',
        'icon': Icons.visibility,
        'color': Colors.indigo,
      },
      {
        'title': 'Data & Analytics',
        'icon': Icons.show_chart,
        'color': Colors.blue,
      },
      {
        'title': 'Help & Support',
        'icon': Icons.description,
        'color': Colors.grey,
      },
      {
        'title': 'Rate us',
        'icon': Icons.star_border,
        'color': Colors.amber,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(settings.length, (index) {
          final setting = settings[index];
          return InkWell(
            onTap: () {
              if (setting['route'] != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => setting['route'] as Widget,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${setting['title']}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: clampDouble(size.width * 0.05, 16, 24),
                vertical: spacing * 0.75,
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: clampDouble(size.width * 0.1, 36, 44),
                    height: clampDouble(size.width * 0.1, 36, 44),
                    decoration: BoxDecoration(
                      color: (setting['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(borderRadius * 0.75),
                    ),
                    child: Icon(
                      setting['icon'] as IconData,
                      color: setting['color'] as Color,
                      size: fontSize * 1.2,
                    ),
                  ),
                  SizedBox(width: spacing),
                  // Title
                  Expanded(
                    child: Text(
                      setting['title'] as String,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF212121),
                      ),
                    ),
                  ),
                  // Chevron Icon
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: fontSize * 1.2,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLogoutOption(
    Size size,
    Function clampDouble,
    double fontSize,
    double spacing,
    double borderRadius,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Show logout confirmation dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<AccountBloc>().add(const LogoutEvent());
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: clampDouble(size.width * 0.05, 16, 24),
            vertical: spacing * 0.75,
          ),
          child: Row(
            children: [
              // Logout Icon
              Container(
                width: clampDouble(size.width * 0.1, 36, 44),
                height: clampDouble(size.width * 0.1, 36, 44),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(borderRadius * 0.75),
                ),
                child: const Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              SizedBox(width: spacing),
              // Logout Text
              Expanded(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

