import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/injections/injection_container.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';
import '../../../../features/account/presentation/bloc/account_bloc.dart';
import '../../../../features/account/presentation/bloc/account_event.dart';

class ChooseTopUpMethodPage extends StatefulWidget {
  final double amount;

  const ChooseTopUpMethodPage({
    super.key,
    required this.amount,
  });

  @override
  State<ChooseTopUpMethodPage> createState() => _ChooseTopUpMethodPageState();
}

class _ChooseTopUpMethodPageState extends State<ChooseTopUpMethodPage> {
  int _selectedMethodIndex = 3; // Mastercard is selected by default

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'PayPal',
      'icon': Icons.payment,
      'iconColor': Colors.blue[700]!,
      'iconBgColor': Colors.blue[50],
      'details': 'andrew.ainsley@yourdomain.com',
      'type': 'email',
      'method': 'PAYPAL',
    },
    {
      'name': 'Google Pay',
      'icon': Icons.account_circle,
      'iconColor': Colors.blue,
      'iconBgColor': Colors.blue[50],
      'details': 'andrew.ainsley@yourdomain.com',
      'type': 'email',
      'method': 'GOOGLE_PAY',
    },
    {
      'name': 'Apple Pay',
      'icon': Icons.apple,
      'iconColor': Colors.black,
      'iconBgColor': Colors.grey[100]!,
      'details': 'andrew.ainsley@yourdomain.com',
      'type': 'email',
      'method': 'APPLE_PAY',
    },
    {
      'name': 'Mastercard',
      'icon': Icons.credit_card,
      'iconColor': Colors.orange,
      'iconBgColor': Colors.orange[50]!,
      'details': '.... .... .... 4679',
      'type': 'card',
      'method': 'CARD',
    },
    {
      'name': 'Visa',
      'icon': Icons.credit_card,
      'iconColor': Colors.blue[900]!,
      'iconBgColor': Colors.blue[50],
      'details': '.... .... .... 5567',
      'type': 'card',
      'method': 'CARD',
    },
    {
      'name': 'American Express',
      'icon': Icons.credit_card,
      'iconColor': Colors.blue[800]!,
      'iconBgColor': Colors.blue[50],
      'details': '.... .... .... 8456',
      'type': 'card',
      'method': 'CARD',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.055, 20, 24);
    final listItemTitleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final listItemSubtitleFontSize = clampDouble(size.width * 0.035, 12, 14);
    final buttonFontSize = clampDouble(size.width * 0.042, 14, 16);
    final spacing = clampDouble(size.height * 0.02, 12, 20);
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<AccountBloc>()),
        BlocProvider(create: (_) => sl<WalletBloc>()),
      ],
      child: BlocListener<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is TopUpSuccess) {
            // Refresh profile to get updated balance
            context.read<AccountBloc>().add(const GetProfileEvent());
            // Show success dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => _TopUpSuccessDialog(amount: widget.amount),
            );
          } else if (state is WalletError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Choose Top Up Method',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF212121),
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF212121)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add payment method feature coming soon'),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(horizontalPadding),
                  itemCount: _paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = _paymentMethods[index];
                    final isSelected = _selectedMethodIndex == index;
                    return Padding(
                      padding: EdgeInsets.only(bottom: spacing),
                      child: _buildPaymentMethodCard(
                        size,
                        clampDouble,
                        method,
                        isSelected,
                        listItemTitleFontSize,
                        listItemSubtitleFontSize,
                        spacing,
                        borderRadius,
                        index,
                      ),
                    );
                  },
                ),
              ),
              // Confirm Button
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
                  child: BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, state) {
                      final isLoading = state is WalletLoading;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _onConfirmTopUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: EdgeInsets.symmetric(
                              vertical: clampDouble(size.height * 0.02, 14, 18),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Confirm Top Up - \$${widget.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: buttonFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onConfirmTopUp() {
    final method = _paymentMethods[_selectedMethodIndex];
    context.read<WalletBloc>().add(TopUpEvent(
          amount: widget.amount,
          paymentMethod: method['method'] as String,
          paymentMethodDetails: method['details'] as String,
        ));
  }

  Widget _buildPaymentMethodCard(
    Size size,
    Function clampDouble,
    Map<String, dynamic> method,
    bool isSelected,
    double titleFontSize,
    double subtitleFontSize,
    double spacing,
    double borderRadius,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethodIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(clampDouble(size.width * 0.04, 12, 16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: clampDouble(size.width * 0.12, 40, 50),
              height: clampDouble(size.width * 0.12, 40, 50),
              decoration: BoxDecoration(
                color: (method['iconBgColor'] as Color),
                borderRadius: BorderRadius.circular(borderRadius * 0.75),
              ),
              child: Icon(
                method['icon'] as IconData,
                color: method['iconColor'] as Color,
                size: 24,
              ),
            ),
            SizedBox(width: spacing),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['name'] as String,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: spacing * 0.25),
                  Text(
                    method['details'] as String,
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Checkmark
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF4CAF50),
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}

class _TopUpSuccessDialog extends StatelessWidget {
  final double amount;

  const _TopUpSuccessDialog({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            // Title
            const Text(
              'Top Up Successful!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              'You\'ve successfully added \$${amount.toStringAsFixed(2)} to your GoRide Wallet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            // OK Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to account
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

