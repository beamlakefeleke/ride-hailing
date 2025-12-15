import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../config/injections/injection_container.dart';
import '../../../../driver_en_route_screen.dart';
import '../../../../ride_details_screen.dart';
import '../bloc/activity_bloc.dart';
import '../bloc/activity_event.dart';
import '../bloc/activity_state.dart';
import '../../../rides/domain/entities/ride.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _selectedTabIndex = 0; // 0: Ongoing, 1: Scheduled, 2: Completed, 3: Cancelled, 4: Top Up

  @override
  void initState() {
    super.initState();
    // Load initial tab data
    context.read<ActivityBloc>().add(const LoadOngoingRidesEvent());
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    context.read<ActivityBloc>().add(SwitchTabEvent(index));
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final rideDate = DateTime(date.year, date.month, date.day);

    if (rideDate == today) {
      return 'Today, ${DateFormat('MMM d, yyyy').format(date)} - ${DateFormat('hh:mm a').format(date)}';
    } else {
      return DateFormat('MMM d, yyyy - hh:mm a').format(date);
    }
  }

  String _formatScheduledTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  String _formatScheduledDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  String _formatCompletedDate(DateTime date) {
    return DateFormat('MMM d, yyyy - hh:mm a').format(date);
  }

  String _formatCancelledDate(DateTime date) {
    return DateFormat('MMM d, yyyy - hh:mm a').format(date);
  }


  String _getRideTypeIcon(String rideType) {
    switch (rideType.toUpperCase()) {
      case 'SCOOTER':
      case 'MOTORBIKE':
        return 'scooter';
      default:
        return 'car';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final tabFontSize = clampDouble(size.width * 0.038, 13, 15);
    final cardTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final cardSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final buttonFontSize = clampDouble(size.width * 0.038, 13, 15);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final tabPadding = clampDouble(size.width * 0.03, 10, 14);

    return BlocProvider(
      create: (context) => sl<ActivityBloc>()..add(const LoadOngoingRidesEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(size, clampDouble, horizontalPadding),
        body: Column(
          children: [
            // Horizontal Navigation Tabs
            _buildTabs(size, clampDouble, tabFontSize, tabPadding, borderRadius),
            // Content
            Expanded(
              child: BlocBuilder<ActivityBloc, ActivityState>(
                builder: (context, state) {
                  return _buildContent(
                    context,
                    size,
                    clampDouble,
                    horizontalPadding,
                    cardTitleFontSize,
                    cardSubtitleFontSize,
                    buttonFontSize,
                    spacing,
                    borderRadius,
                    state,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Size size, Function clampDouble, double horizontalPadding) {
    final logoSize = clampDouble(size.width * 0.08, 32, 40);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);

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
        'Activity',
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

  Widget _buildTabs(
    Size size,
    Function clampDouble,
    double fontSize,
    double padding,
    double borderRadius,
  ) {
    final tabs = ['Ongoing', 'Scheduled', 'Completed', 'Cancelled', 'Top Up'];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: clampDouble(size.width * 0.05, 16, 24),
        vertical: clampDouble(size.height * 0.015, 10, 16),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = _selectedTabIndex == index;
            return Padding(
              padding: EdgeInsets.only(
                right: index < tabs.length - 1 ? padding * 0.75 : 0,
              ),
              child: GestureDetector(
                onTap: () => _onTabChanged(index),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding,
                    vertical: padding * 0.6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF4CAF50)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius * 2),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4CAF50)
                          : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF212121),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double cardTitleFontSize,
    double cardSubtitleFontSize,
    double buttonFontSize,
    double spacing,
    double borderRadius,
    ActivityState state,
  ) {
    if (state is ActivityLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ActivityError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.message,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: spacing),
            ElevatedButton(
              onPressed: () {
                context.read<ActivityBloc>().add(SwitchTabEvent(_selectedTabIndex));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_selectedTabIndex == 0) {
      // Ongoing tab
      if (state is OngoingRidesLoaded) {
        return _buildOngoingContent(
          context,
          size,
          clampDouble,
          horizontalPadding,
          cardTitleFontSize,
          cardSubtitleFontSize,
          buttonFontSize,
          spacing,
          borderRadius,
          state.rides,
        );
      }
    } else if (_selectedTabIndex == 1) {
      // Scheduled tab
      if (state is ScheduledRidesLoaded) {
        return _buildScheduledContent(
          size,
          clampDouble,
          horizontalPadding,
          spacing,
          state.rides,
        );
      }
    } else if (_selectedTabIndex == 2) {
      // Completed tab
      if (state is CompletedRidesLoaded) {
        return _buildCompletedContent(
          context,
          size,
          clampDouble,
          horizontalPadding,
          spacing,
          state.rides,
        );
      }
    } else if (_selectedTabIndex == 3) {
      // Cancelled tab
      if (state is CancelledRidesLoaded) {
        return _buildCancelledContent(
          context,
          size,
          clampDouble,
          horizontalPadding,
          spacing,
          state.rides,
        );
      }
    } else {
      // Top Up tab (placeholder - not implemented in backend yet)
      return _buildTopUpContent(
        context,
        size,
        clampDouble,
        horizontalPadding,
        spacing,
      );
    }

    return const Center(
      child: Text('No data available'),
    );
  }

  Widget _buildOngoingContent(
    BuildContext context,
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double cardTitleFontSize,
    double cardSubtitleFontSize,
    double buttonFontSize,
    double spacing,
    double borderRadius,
    List<Ride> rides,
  ) {
    if (rides.isEmpty) {
      return Center(
        child: Text(
          'No ongoing rides',
          style: TextStyle(
            fontSize: cardTitleFontSize,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    final ride = rides.first; // Show first ongoing ride
    return SingleChildScrollView(
      padding: EdgeInsets.all(horizontalPadding),
      child: _buildOngoingRideCard(
        context,
        size,
        clampDouble,
        horizontalPadding,
        cardTitleFontSize,
        cardSubtitleFontSize,
        buttonFontSize,
        spacing,
        borderRadius,
        ride,
      ),
    );
  }

  Widget _buildOngoingRideCard(
    BuildContext context,
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double cardTitleFontSize,
    double cardSubtitleFontSize,
    double buttonFontSize,
    double spacing,
    double borderRadius,
    Ride ride,
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
      child: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Car icon, Destination, Fare
            Row(
              children: [
                // Car Icon
                Container(
                  padding: EdgeInsets.all(spacing * 0.5),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(borderRadius * 0.5),
                    border: Border.all(
                      color: const Color(0xFF4CAF50),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    _getRideTypeIcon(ride.rideType) == 'scooter'
                        ? Icons.two_wheeler
                        : Icons.directions_car,
                    color: const Color(0xFF4CAF50),
                    size: clampDouble(size.width * 0.06, 22, 28),
                  ),
                ),
                SizedBox(width: spacing),
                // Destination
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.destinationAddress,
                        style: TextStyle(
                          fontSize: cardTitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing * 0.25),
                      Text(
                        _formatDate(ride.createdAt),
                        style: TextStyle(
                          fontSize: cardSubtitleFontSize,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Fare
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${ride.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: cardTitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      'Wallet', // Payment method - would need to be added to backend
                      style: TextStyle(
                        fontSize: cardSubtitleFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: spacing * 1.5),
            // Route Information
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location pins column
                Column(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: const Color(0xFF4CAF50),
                      size: clampDouble(size.width * 0.06, 22, 28),
                    ),
                    Container(
                      width: 2,
                      height: spacing * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    Icon(
                      Icons.location_on,
                      color: Colors.red[400],
                      size: clampDouble(size.width * 0.06, 22, 28),
                    ),
                  ],
                ),
                SizedBox(width: spacing * 0.75),
                // Location names column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.pickupAddress,
                        style: TextStyle(
                          fontSize: cardSubtitleFontSize,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF212121),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing * 0.8),
                      Text(
                        ride.destinationAddress,
                        style: TextStyle(
                          fontSize: cardSubtitleFontSize,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF212121),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing * 1.5),
            // Track Route Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DriverEnRouteScreen(
                        destination: {
                          'name': ride.destinationAddress,
                          'lat': ride.destinationLatitude,
                          'lng': ride.destinationLongitude,
                        },
                        pickupLocation: {
                          'name': ride.pickupAddress,
                          'lat': ride.pickupLatitude,
                          'lng': ride.pickupLongitude,
                        },
                        selectedRide: {
                          'name': 'GoRide ${ride.rideType}',
                          'price': ride.price,
                        },
                        selectedPayment: {
                          'name': 'Wallet',
                        },
                        selectedPromo: null,
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: clampDouble(size.height * 0.02, 14, 18),
                  ),
                  side: const BorderSide(
                    color: Color(0xFF4CAF50),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
                child: Text(
                  'Track Route',
                  style: TextStyle(
                    fontSize: buttonFontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduledContent(
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double spacing,
    List<Ride> rides,
  ) {
    if (rides.isEmpty) {
      return Center(
        child: Text(
          'No scheduled rides',
          style: TextStyle(
            fontSize: clampDouble(size.width * 0.042, 14, 16),
            color: Colors.grey[600],
          ),
        ),
      );
    }

    final cardTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final cardSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final iconContainerSize = clampDouble(size.width * 0.14, 48, 56);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: spacing * 0.5),
      itemCount: rides.length,
      itemBuilder: (context, index) {
        final ride = rides[index];
        return _buildScheduledRideItem(
          context,
          size,
          clampDouble,
          ride,
          cardTitleFontSize,
          cardSubtitleFontSize,
          iconSize,
          iconContainerSize,
          spacing,
          index < rides.length - 1,
        );
      },
    );
  }

  Widget _buildScheduledRideItem(
    BuildContext context,
    Size size,
    Function clampDouble,
    Ride ride,
    double titleFontSize,
    double subtitleFontSize,
    double iconSize,
    double iconContainerSize,
    double spacing,
    bool showDivider,
  ) {
    final scheduledDate = ride.scheduledDateTime ?? ride.createdAt;

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RideDetailsScreen(ride: _rideToMap(ride)),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  width: iconContainerSize,
                  height: iconContainerSize,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4CAF50),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    _getRideTypeIcon(ride.rideType) == 'scooter'
                        ? Icons.two_wheeler
                        : Icons.directions_car,
                    color: const Color(0xFF4CAF50),
                    size: iconSize,
                  ),
                ),
                SizedBox(width: spacing),
                // Destination and Booking Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.destinationAddress,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing * 0.25),
                      Text(
                        _formatDate(ride.createdAt),
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacing * 0.5),
                // Scheduled Time and Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatScheduledTime(scheduledDate),
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      _formatScheduledDate(scheduledDate),
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
          ),
      ],
    );
  }

  Widget _buildCompletedContent(
    BuildContext context,
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double spacing,
    List<Ride> rides,
  ) {
    if (rides.isEmpty) {
      return Center(
        child: Text(
          'No completed rides',
          style: TextStyle(
            fontSize: clampDouble(size.width * 0.042, 14, 16),
            color: Colors.grey[600],
          ),
        ),
      );
    }

    final cardTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final cardSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final iconContainerSize = clampDouble(size.width * 0.14, 48, 56);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: spacing * 0.5),
      itemCount: rides.length,
      itemBuilder: (context, index) {
        final ride = rides[index];
        return _buildCompletedRideItem(
          context,
          size,
          clampDouble,
          ride,
          cardTitleFontSize,
          cardSubtitleFontSize,
          iconSize,
          iconContainerSize,
          spacing,
          index < rides.length - 1,
        );
      },
    );
  }

  Widget _buildCompletedRideItem(
    BuildContext context,
    Size size,
    Function clampDouble,
    Ride ride,
    double titleFontSize,
    double subtitleFontSize,
    double iconSize,
    double iconContainerSize,
    double spacing,
    bool showDivider,
  ) {
    final completedDate = ride.completedAt ?? ride.updatedAt;

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RideDetailsScreen(ride: _rideToMap(ride)),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  width: iconContainerSize,
                  height: iconContainerSize,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4CAF50),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    _getRideTypeIcon(ride.rideType) == 'scooter'
                        ? Icons.two_wheeler
                        : Icons.directions_car,
                    color: const Color(0xFF4CAF50),
                    size: iconSize,
                  ),
                ),
                SizedBox(width: spacing),
                // Destination and Completion Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.destinationAddress,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing * 0.25),
                      Text(
                        _formatCompletedDate(completedDate),
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacing * 0.5),
                // Fare and Payment Method
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${ride.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      'Wallet', // Payment method - would need to be added to backend
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
          ),
      ],
    );
  }

  Widget _buildCancelledContent(
    BuildContext context,
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double spacing,
    List<Ride> rides,
  ) {
    if (rides.isEmpty) {
      return Center(
        child: Text(
          'No cancelled rides',
          style: TextStyle(
            fontSize: clampDouble(size.width * 0.042, 14, 16),
            color: Colors.grey[600],
          ),
        ),
      );
    }

    final cardTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final cardSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final statusFontSize = clampDouble(size.width * 0.032, 11, 13);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final iconContainerSize = clampDouble(size.width * 0.14, 48, 56);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: spacing * 0.5),
      itemCount: rides.length,
      itemBuilder: (context, index) {
        final ride = rides[index];
        return _buildCancelledRideItem(
          context,
          size,
          clampDouble,
          ride,
          cardTitleFontSize,
          cardSubtitleFontSize,
          statusFontSize,
          iconSize,
          iconContainerSize,
          spacing,
          index < rides.length - 1,
        );
      },
    );
  }

  Widget _buildCancelledRideItem(
    BuildContext context,
    Size size,
    Function clampDouble,
    Ride ride,
    double titleFontSize,
    double subtitleFontSize,
    double statusFontSize,
    double iconSize,
    double iconContainerSize,
    double spacing,
    bool showDivider,
  ) {
    final cancelledDate = ride.cancelledAt ?? ride.updatedAt;

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RideDetailsScreen(ride: _rideToMap(ride)),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: spacing * 0.75),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  width: iconContainerSize,
                  height: iconContainerSize,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4CAF50),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    _getRideTypeIcon(ride.rideType) == 'scooter'
                        ? Icons.two_wheeler
                        : Icons.directions_car,
                    color: const Color(0xFF4CAF50),
                    size: iconSize,
                  ),
                ),
                SizedBox(width: spacing),
                // Destination and Cancellation Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.destinationAddress,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing * 0.25),
                      Text(
                        _formatCancelledDate(cancelledDate),
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacing * 0.5),
                // Fare and Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${ride.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      'Canceled & Refunded',
                      style: TextStyle(
                        fontSize: statusFontSize,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
          ),
      ],
    );
  }

  Widget _buildTopUpContent(
    BuildContext context,
    Size size,
    Function clampDouble,
    double horizontalPadding,
    double spacing,
  ) {
    // Placeholder - Top-up transactions not implemented in backend yet
    return Center(
      child: Text(
        'Top-up transactions coming soon',
        style: TextStyle(
          fontSize: clampDouble(size.width * 0.042, 14, 16),
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Map<String, dynamic> _rideToMap(Ride ride) {
    return {
      'id': ride.id,
      'destination': ride.destinationAddress,
      'pickup': ride.pickupAddress,
      'rideType': _getRideTypeIcon(ride.rideType),
      'fare': ride.price,
      'status': ride.status.toLowerCase(),
      'completedDate': ride.completedAt,
      'cancelledDate': ride.cancelledAt,
      'bookedDate': ride.createdAt,
      'scheduledDate': ride.scheduledDateTime,
      'paymentMethod': 'Wallet', // Would need to be added to backend
    };
  }
}

