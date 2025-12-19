// viewmodels/payment_state.dart

import 'package:equatable/equatable.dart';
import '../../models/PaymentMethodM/payment_method_model.dart';


abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final List<PaymentMethodModel> methods;

  const PaymentLoaded({required this.methods});

  @override
  List<Object> get props => [methods];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError({required this.message});

  @override
  List<Object> get props => [message];
}