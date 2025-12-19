// lib/bloc/user_address_insert/user_address_insert_state.dart

import 'package:equatable/equatable.dart';

import '../../../models/AddressM/user_address_insert_model.dart';

abstract class UserAddressInsertState extends Equatable {
  const UserAddressInsertState();

  @override
  List<Object> get props => [];
}

/// Initial state for the address insertion process.
class UserAddressInsertInitial extends UserAddressInsertState {}

/// State indicating the address insertion is in progress.
class UserAddressInsertLoading extends UserAddressInsertState {}

/// State indicating a successful address insertion.
class UserAddressInsertSuccess extends UserAddressInsertState {
  final UserAddressInsertResponse response;

  const UserAddressInsertSuccess(this.response);

  @override
  List<Object> get props => [response];
}

/// State indicating an error occurred during address insertion.
class UserAddressInsertFailure extends UserAddressInsertState {
  final String error;

  const UserAddressInsertFailure(this.error);

  @override
  List<Object> get props => [error];
}