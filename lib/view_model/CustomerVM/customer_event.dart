// lib/view_model/CustomerVM/CustomerEvent.dart
abstract class CustomerEvent {}

class FetchCustomerEvent extends CustomerEvent {
  final int customerId;
  FetchCustomerEvent(this.customerId);
}