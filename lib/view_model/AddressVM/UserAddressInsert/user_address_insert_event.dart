// lib/bloc/user_address_insert/user_address_insert_event.dart

import 'package:equatable/equatable.dart';

import '../../../models/AddressM/user_address_insert_model.dart';

abstract class UserAddressInsertEvent extends Equatable {
  const UserAddressInsertEvent();

  @override
  List<Object> get props => [];
}

/// Event to trigger the insertion of a new user address.
class InsertUserAddress extends UserAddressInsertEvent {
  final UserAddressInsertRequest request;

  const InsertUserAddress(this.request);

  @override
  List<Object> get props => [request];
}