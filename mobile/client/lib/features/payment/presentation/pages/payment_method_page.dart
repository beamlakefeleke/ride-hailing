import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/injections/injection_container.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';

class PaymentMethodPage extends StatelessWidget {
  const PaymentMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 26);
    final paymentNameSize = clampDouble(size.width * 0.042, 14, 16);
    final paymentSubtitleSize = clampDouble(size.width * 0.035, 12, 14);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final buttonPadding = clampDouble(size.height * 0.022, 14, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final paymentIconSize = clampDouble(size.width * 0.12, 50, 70);

    return BlocProvider(
      create: (context) => sl<PaymentBloc>()..add(const LoadPaymentMethodsEvent()),
      child: Container(
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
                        'Choose Payment Method',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.black87),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Add payment method feature coming soon!'),
                            backgroundColor: Color(0xFF4CAF50),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Payment Methods List
              Expanded(
                child: BlocBuilder<PaymentBloc, PaymentState>(
                  builder: (context, state) {
                    if (state is PaymentLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is PaymentError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (state is PaymentMethodsLoaded) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.all(horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: spacing),
                            ...List.generate(state.methods.length, (index) {
                              final payment = state.methods[index];
                              final isSelected = state.selectedIndex == index;
                              return Padding(
                                padding: EdgeInsets.only(bottom: spacing),
                                child: _buildPaymentCard(
                                  payment,
                                  isSelected,
                                  paymentNameSize,
                                  paymentSubtitleSize,
                                  borderRadius,
                                  spacing,
                                  paymentIconSize,
                                  iconSize,
                                  () {
                                    context.read<PaymentBloc>().add(
                                          SelectPaymentMethodEvent(index),
                                        );
                                  },
                                ),
                              );
                            }),
                            SizedBox(height: spacing),
                          ],
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              // OK Button
              BlocBuilder<PaymentBloc, PaymentState>(
                builder: (context, state) {
                  if (state is PaymentMethodsLoaded) {
                    return Container(
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
                            onPressed: () {
                              final selectedPayment = state.methods[state.selectedIndex];
                              Navigator.of(context).pop(selectedPayment.toJson());
                            },
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
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(
    PaymentMethod payment,
    bool isSelected,
    double nameSize,
    double subtitleSize,
    double borderRadius,
    double spacing,
    double iconSize,
    double checkIconSize,
    VoidCallback onTap,
  ) {
    final iconData = _getIconData(payment.icon);
    final iconColor = _parseColor(payment.iconColor);
    final backgroundColor = _parseColor(payment.backgroundColor);

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
            // Payment Icon
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: payment.type == 'wallet'
                    ? BorderRadius.circular(borderRadius * 0.5)
                    : BorderRadius.circular(iconSize / 2),
                border: payment.type == 'wallet'
                    ? null
                    : Border.all(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
              ),
              child: _buildPaymentIcon(
                payment,
                iconData,
                iconColor,
                iconSize,
              ),
            ),
            SizedBox(width: spacing),
            // Payment Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment.name,
                    style: TextStyle(
                      fontSize: nameSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: spacing * 0.25),
                  Text(
                    payment.subtitle,
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: Colors.grey[600],
                    ),
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

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'attach_money':
        return Icons.attach_money;
      case 'payment':
        return Icons.payment;
      case 'account_circle':
        return Icons.account_circle;
      case 'apple':
        return Icons.apple;
      case 'credit_card':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  Color _parseColor(String colorString) {
    if (colorString.startsWith('#')) {
      return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
    }
    return Colors.white;
  }

  Widget _buildPaymentIcon(
    PaymentMethod payment,
    IconData iconData,
    Color iconColor,
    double size,
  ) {
    if (payment.type == 'paypal') {
      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0070BA),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            'P',
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else if (payment.type == 'wallet') {
      return Stack(
        children: [
          Icon(
            iconData,
            color: Colors.white,
            size: size * 0.5,
          ),
          Positioned(
            top: size * 0.15,
            right: size * 0.15,
            child: Container(
              width: size * 0.2,
              height: 2,
              color: Colors.white,
            ),
          ),
        ],
      );
    } else {
      return Icon(
        iconData,
        color: iconColor,
        size: size * 0.6,
      );
    }
  }
}

