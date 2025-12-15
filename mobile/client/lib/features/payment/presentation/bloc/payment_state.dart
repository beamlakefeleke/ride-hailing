import 'package:equatable/equatable.dart';

class PaymentMethod {
  final String name;
  final String type;
  final String subtitle;
  final String icon;
  final String iconColor;
  final String backgroundColor;

  PaymentMethod({
    required this.name,
    required this.type,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'subtitle': subtitle,
        'icon': icon,
        'iconColor': iconColor,
        'backgroundColor': backgroundColor,
      };
}

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentMethodsLoaded extends PaymentState {
  final List<PaymentMethod> methods;
  final int selectedIndex;

  const PaymentMethodsLoaded({
    required this.methods,
    this.selectedIndex = 0,
  });

  @override
  List<Object> get props => [methods, selectedIndex];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object> get props => [message];
}

