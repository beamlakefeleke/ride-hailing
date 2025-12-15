import 'package:bloc/bloc.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    on<LoadPaymentMethodsEvent>(_onLoadPaymentMethods);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
  }

  void _onLoadPaymentMethods(
    LoadPaymentMethodsEvent event,
    Emitter<PaymentState> emit,
  ) {
    // In a real app, this would fetch from backend
    // For now, return hardcoded payment methods
    final methods = [
      PaymentMethod(
        name: 'OurRide Wallet',
        type: 'wallet',
        subtitle: 'Available balance: \$2,069.50',
        icon: 'account_balance_wallet',
        iconColor: '#4CAF50',
        backgroundColor: '#4CAF50',
      ),
      PaymentMethod(
        name: 'Cash',
        type: 'cash',
        subtitle: 'Pay drivers cash directly',
        icon: 'attach_money',
        iconColor: '#4CAF50',
        backgroundColor: '#FFFFFF',
      ),
      PaymentMethod(
        name: 'PayPal',
        type: 'paypal',
        subtitle: 'andrew.ainsley@yourdomain.com',
        icon: 'payment',
        iconColor: '#0070BA',
        backgroundColor: '#FFFFFF',
      ),
      PaymentMethod(
        name: 'Google Pay',
        type: 'google',
        subtitle: 'andrew.ainsley@yourdomain.com',
        icon: 'account_circle',
        iconColor: '#000000',
        backgroundColor: '#FFFFFF',
      ),
      PaymentMethod(
        name: 'Apple Pay',
        type: 'apple',
        subtitle: 'andrew.ainsley@yourdomain.com',
        icon: 'apple',
        iconColor: '#000000',
        backgroundColor: '#FFFFFF',
      ),
      PaymentMethod(
        name: 'Mastercard',
        type: 'card',
        subtitle: '... ... ... 4679',
        icon: 'credit_card',
        iconColor: '#000000',
        backgroundColor: '#FFFFFF',
      ),
    ];

    emit(PaymentMethodsLoaded(methods: methods, selectedIndex: 0));
  }

  void _onSelectPaymentMethod(
    SelectPaymentMethodEvent event,
    Emitter<PaymentState> emit,
  ) {
    if (state is PaymentMethodsLoaded) {
      final currentState = state as PaymentMethodsLoaded;
      emit(PaymentMethodsLoaded(
        methods: currentState.methods,
        selectedIndex: event.index,
      ));
    }
  }
}

