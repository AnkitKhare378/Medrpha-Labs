import '../../models/CustomerM/customer_model.dart';

abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final CustomerData customer;
  CustomerLoaded(this.customer);
}

class CustomerError extends CustomerState {
  final String message;
  CustomerError(this.message);
}