import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class LoadPaymentMethodsEvent extends PaymentEvent {
  const LoadPaymentMethodsEvent();
}

class SelectPaymentMethodEvent extends PaymentEvent {
  final int index;

  const SelectPaymentMethodEvent(this.index);

  @override
  List<Object> get props => [index];
}

