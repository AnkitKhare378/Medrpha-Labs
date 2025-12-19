// lib/view_model/UpdateWalletVM/update_wallet_state.dart

import 'package:equatable/equatable.dart';

abstract class UpdateWalletState extends Equatable {
  const UpdateWalletState();

  @override
  List<Object> get props => [];
}

class UpdateWalletInitial extends UpdateWalletState {}

class UpdateWalletLoading extends UpdateWalletState {}

class UpdateWalletSuccess extends UpdateWalletState {
  final double newBalance;
  const UpdateWalletSuccess(this.newBalance);

  @override
  List<Object> get props => [newBalance];
}

class UpdateWalletError extends UpdateWalletState {
  final String message;
  const UpdateWalletError(this.message);

  @override
  List<Object> get props => [message];
}