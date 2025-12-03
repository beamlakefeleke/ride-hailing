import 'package:flutter/material.dart';

class PromosScreen extends StatefulWidget {
  const PromosScreen({super.key});

  @override
  State<PromosScreen> createState() => _PromosScreenState();
}

class _PromosScreenState extends State<PromosScreen> {
  final TextEditingController _promoCodeController = TextEditingController();
  int? _selectedPromoIndex;

  final List<Map<String, dynamic>> _promos = [
    {
      'title': 'Best Deal: 20% OFF',
      'code': 'EOYP25',
      'description': 'No min. spend',
      'validTill': 'Valid till 12/31/2024',
      'isBestDeal': true,
    },
    {
      'title': '15% OFF: New User Promotion',
      'code': 'NUP15K',
      'description': 'Min. spend \$8.00',
      'validTill': 'Valid till 12/28/2024',
      'isBestDeal': false,
    },
    {
      'title': '10% OFF & 10% Cashback',
      'code': '10OFFC',
      'description': 'Min. spend \$8.00',
      'validTill': 'Valid till 12/30/2024',
      'isBestDeal': false,
    },
    {
      'title': '8% OFF & 8% Cashback',
      'code': '8OFF8C',
      'description': 'Min. spend \$10.00',
      'validTill': 'Valid till 12/30/2024',
      'isBestDeal': false,
    },
    {
      'title': '12% Cashback',
      'code': 'C12BACK',
      'description': 'Min. spend \$12.00',
      'validTill': 'Valid till 12/31/2024',
      'isBestDeal': false,
    },
  ];

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  void _onRedeem() {
    if (_promoCodeController.text.isNotEmpty) {
      // Handle promo code redemption
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Promo code ${_promoCodeController.text} redeemed!'),
          backgroundColor: const Color(0xFF4CAF50),
        ),
      );
    }
  }

  void _onOK() {
    Navigator.of(context).pop(_selectedPromoIndex != null
        ? _promos[_selectedPromoIndex!]
        : null);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 26);
    final promoTitleSize = clampDouble(size.width * 0.042, 14, 16);
    final promoSubtitleSize = clampDouble(size.width * 0.035, 12, 14);
    final inputFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonPadding = clampDouble(size.height * 0.022, 14, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final promoIconSize = clampDouble(size.width * 0.12, 50, 70);

    return Container(
      height: size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Drag Handle
            Container(
              margin: EdgeInsets.only(top: spacing * 0.5, bottom: spacing * 0.5),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Promos / Vouchers',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: iconSize), // Balance the back button
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: spacing),
                    // Have a Promo Code Section
                    Text(
                      'Have a Promo Code?',
                      style: TextStyle(
                        fontSize: promoTitleSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: spacing * 0.75),
                    // Promo Code Input
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(borderRadius),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                            child: TextField(
                              controller: _promoCodeController,
                              style: TextStyle(
                                fontSize: inputFontSize,
                                color: const Color(0xFF212121),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter code here',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: inputFontSize,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: spacing,
                                  vertical: spacing * 0.75,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: spacing * 0.75),
                        ElevatedButton(
                          onPressed: _onRedeem,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing * 1.5,
                              vertical: spacing * 0.75,
                            ),
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Redeem',
                            style: TextStyle(
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing * 2),
                    // Promo Cards List
                    ...List.generate(_promos.length, (index) {
                      final promo = _promos[index];
                      final isSelected = _selectedPromoIndex == index;
                      return Padding(
                        padding: EdgeInsets.only(bottom: spacing),
                        child: _buildPromoCard(
                          promo,
                          isSelected,
                          promoTitleSize,
                          promoSubtitleSize,
                          borderRadius,
                          spacing,
                          promoIconSize,
                          iconSize,
                          () {
                            setState(() {
                              _selectedPromoIndex = isSelected ? null : index;
                            });
                          },
                        ),
                      );
                    }),
                    SizedBox(height: spacing),
                  ],
                ),
              ),
            ),
            // OK Button
            Container(
              padding: EdgeInsets.all(horizontalPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onOK,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: buttonPadding),
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard(
    Map<String, dynamic> promo,
    bool isSelected,
    double titleSize,
    double subtitleSize,
    double borderRadius,
    double spacing,
    double iconSize,
    double checkIconSize,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4CAF50)
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Orange Percentage Icon
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: Colors.orange[400],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.percent,
                color: Colors.white,
                size: iconSize * 0.5,
              ),
            ),
            SizedBox(width: spacing),
            // Promo Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (promo['isBestDeal'] as bool) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing * 0.5,
                            vertical: spacing * 0.25,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Best Deal',
                            style: TextStyle(
                              fontSize: subtitleSize * 0.85,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                        SizedBox(width: spacing * 0.5),
                      ],
                      Expanded(
                        child: Text(
                          promo['title'] as String,
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF212121),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing * 0.5),
                  Row(
                    children: [
                      Text(
                        '${promo['code']}',
                        style: TextStyle(
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        ' · ',
                        style: TextStyle(
                          fontSize: subtitleSize,
                          color: Colors.grey[600],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${promo['description']} · ${promo['validTill']}',
                          style: TextStyle(
                            fontSize: subtitleSize,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: spacing * 0.5),
            // Checkmark Icon (if selected)
            if (isSelected)
              Container(
                width: checkIconSize * 0.8,
                height: checkIconSize * 0.8,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: checkIconSize * 0.5,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

