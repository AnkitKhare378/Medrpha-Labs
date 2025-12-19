// lib/view_model/UpdateWalletVM/update_wallet_event.dart

import 'package:equatable/equatable.dart';

abstract class UpdateWalletEvent extends Equatable {
  const UpdateWalletEvent();

  @override
  List<Object> get props => [];
}

class AddBalanceToWallet extends UpdateWalletEvent {
  final int userId;
  final double amountToAdd;

  const AddBalanceToWallet({required this.userId, required this.amountToAdd});

  @override
  List<Object> get props => [userId, amountToAdd];
}