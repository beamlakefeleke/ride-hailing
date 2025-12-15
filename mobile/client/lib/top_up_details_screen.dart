import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

class TopUpDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const TopUpDetailsScreen({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  State<TopUpDetailsScreen> createState() => _TopUpDetailsScreenState();
}

class _TopUpDetailsScreenState extends State<TopUpDetailsScreen> {
  void _showShareReceiptModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (context) => _buildShareReceiptModal(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final cardSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final detailLabelFontSize = clampDouble(size.width * 0.038, 13, 15);
    final detailValueFontSize = clampDouble(size.width * 0.038, 13, 15);
    final amountFontSize = clampDouble(size.width * 0.12, 32, 40);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);

    // Extract transaction data
    final amount = widget.transaction['amount'] as double;
    final date = widget.transaction['date'] as DateTime;
    final paymentMethod = widget.transaction['paymentMethod'] as String;
    final cardLast4 = widget.transaction['cardLast4'] as String?;
    final transactionId = widget.transaction['transactionId'] as String;

    // Format payment method display
    String paymentDisplay = paymentMethod;
    if (cardLast4 != null) {
      paymentDisplay = '$paymentMethod (.... $cardLast4)';
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context, size, clampDouble, horizontalPadding, titleFontSize),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacing),
              // Top Up Amount Card
              _buildTopUpAmountCard(
                size,
                clampDouble,
                amount,
                amountFontSize,
                cardSubtitleFontSize,
                paymentDisplay,
                spacing,
                borderRadius,
              ),
              SizedBox(height: spacing),
              // Transaction Details Card
              _buildTransactionDetailsCard(
                size,
                clampDouble,
                date,
                paymentDisplay,
                transactionId,
                detailLabelFontSize,
                detailValueFontSize,
                spacing,
                borderRadius,
                context,
              ),
              SizedBox(height: spacing * 2),
              // Share Receipt Button
              _buildShareReceiptButton(
                size,
                clampDouble,
                spacing,
                borderRadius,
              ),
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
    double horizontalPadding,
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
        'Top Up Details',
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

  Widget _buildTopUpAmountCard(
    Size size,
    Function clampDouble,
    double amount,
    double amountFontSize,
    double subtitleFontSize,
    String paymentDisplay,
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
          // Plus Icon
          Container(
            width: clampDouble(size.width * 0.15, 50, 70),
            height: clampDouble(size.width * 0.15, 50, 70),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(height: spacing * 1.5),
          // Amount
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: amountFontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
          ),
          SizedBox(height: spacing * 0.5),
          // GoRide Wallet
          Text(
            'GoRide Wallet',
            style: TextStyle(
              fontSize: subtitleFontSize * 1.2,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: spacing * 0.75),
          // Payment Method
          Text(
            'From $paymentDisplay',
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetailsCard(
    Size size,
    Function clampDouble,
    DateTime date,
    String paymentMethod,
    String transactionId,
    double labelFontSize,
    double valueFontSize,
    double spacing,
    double borderRadius,
    BuildContext context,
  ) {
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
          _buildDetailRow('Status', 'Completed', labelFontSize, valueFontSize, spacing, isStatus: true),
          SizedBox(height: spacing * 0.75),
          _buildDetailRow('Payment', paymentMethod, labelFontSize, valueFontSize, spacing),
          SizedBox(height: spacing * 0.75),
          _buildDetailRow('Date', DateFormat('MMM d, yyyy').format(date), labelFontSize, valueFontSize, spacing),
          SizedBox(height: spacing * 0.75),
          _buildDetailRow('Time', DateFormat('hh:mm a').format(date), labelFontSize, valueFontSize, spacing),
          SizedBox(height: spacing * 0.75),
          _buildDetailRowWithCopy('Transaction ID', transactionId, labelFontSize, valueFontSize, spacing, context),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    double labelFontSize,
    double valueFontSize,
    double spacing, {
    bool isStatus = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            color: Colors.grey[700],
          ),
        ),
        if (isStatus)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing * 0.75,
              vertical: spacing * 0.25,
            ),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF212121),
            ),
          ),
      ],
    );
  }

  Widget _buildDetailRowWithCopy(
    String label,
    String value,
    double labelFontSize,
    double valueFontSize,
    double spacing,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            color: Colors.grey[700],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF212121),
              ),
            ),
            SizedBox(width: spacing * 0.5),
            GestureDetector(
              onTap: () {
                // Copy to clipboard
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaction ID copied'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Icon(
                Icons.copy,
                size: valueFontSize * 0.9,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShareReceiptButton(
    Size size,
    Function clampDouble,
    double spacing,
    double borderRadius,
  ) {
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _showShareReceiptModal,
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
          'Share Receipt',
          style: TextStyle(
            fontSize: buttonFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4CAF50),
          ),
        ),
      ),
    );
  }

  Widget _buildShareReceiptModal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final sectionLabelFontSize = clampDouble(size.width * 0.035, 12, 14);
    final nameFontSize = clampDouble(size.width * 0.032, 11, 13);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final profileSize = clampDouble(size.width * 0.14, 50, 60);
    final socialIconSize = clampDouble(size.width * 0.18, 60, 70);

    // Extract transaction ID for filename
    final transactionId = widget.transaction['transactionId'] as String;
    final fileName = 'IMG-$transactionId.jpg';

    // Recent people data
    final recentPeople = [
      {'name': 'Charlotte Hanlin', 'icon': Icons.chat, 'color': Colors.green},
      {'name': 'Kristin Watson', 'icon': Icons.facebook, 'color': Colors.blue},
      {'name': 'Clinton McClure', 'icon': Icons.camera_alt, 'color': Colors.orange},
      {'name': 'Maryland Winkles', 'icon': Icons.chat, 'color': Colors.green},
      {'name': 'Ale Her', 'icon': Icons.person, 'color': Colors.grey},
    ];

    // Social media apps
    final socialApps = [
      {'name': 'WhatsApp', 'icon': Icons.chat, 'color': Colors.green},
      {'name': 'Facebook', 'icon': Icons.facebook, 'color': Colors.blue},
      {'name': 'Instagram', 'icon': Icons.camera_alt, 'color': Colors.purple},
      {'name': 'Telegram', 'icon': Icons.send, 'color': Colors.blue},
      {'name': 'X', 'icon': Icons.close, 'color': Colors.black},
    ];

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius * 2),
            topRight: Radius.circular(borderRadius * 2),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: spacing * 0.5),
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: spacing),
                // Title
                Text(
                  'Share Receipt',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: spacing),
                // File Preview
                Container(
                  padding: EdgeInsets.all(spacing),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.description,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: Text(
                          fileName,
                          style: TextStyle(
                            fontSize: clampDouble(size.width * 0.038, 13, 15),
                            color: const Color(0xFF212121),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                // Recent people section
                Text(
                  'Recent people',
                  style: TextStyle(
                    fontSize: sectionLabelFontSize,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: spacing * 0.75),
                SizedBox(
                  height: profileSize + spacing * 1.5,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentPeople.length,
                    itemBuilder: (context, index) {
                      final person = recentPeople[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < recentPeople.length - 1 ? spacing * 0.75 : 0,
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Sharing with ${person['name']}'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: profileSize,
                                    height: profileSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200],
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                        width: 1,
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
                                  // Social media icon overlay
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: profileSize * 0.35,
                                      height: profileSize * 0.35,
                                      decoration: BoxDecoration(
                                        color: person['color'] as Color,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        person['icon'] as IconData,
                                        color: Colors.white,
                                        size: profileSize * 0.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: spacing * 0.25),
                            SizedBox(
                              width: profileSize + spacing,
                              child: Text(
                                person['name'] as String,
                                style: TextStyle(
                                  fontSize: nameFontSize,
                                  color: const Color(0xFF212121),
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                // Social media section
                Text(
                  'Social media',
                  style: TextStyle(
                    fontSize: sectionLabelFontSize,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: spacing * 0.75),
                SizedBox(
                  height: socialIconSize + spacing * 1.5,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: socialApps.length,
                    itemBuilder: (context, index) {
                      final app = socialApps[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < socialApps.length - 1 ? spacing * 0.75 : 0,
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Sharing via ${app['name']}'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Container(
                                width: socialIconSize,
                                height: socialIconSize,
                                decoration: BoxDecoration(
                                  color: app['color'] as Color,
                                  borderRadius: BorderRadius.circular(borderRadius),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  app['icon'] as IconData,
                                  color: Colors.white,
                                  size: socialIconSize * 0.4,
                                ),
                              ),
                            ),
                            SizedBox(height: spacing * 0.25),
                            SizedBox(
                              width: socialIconSize,
                              child: Text(
                                app['name'] as String,
                                style: TextStyle(
                                  fontSize: nameFontSize,
                                  color: const Color(0xFF212121),
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: spacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

