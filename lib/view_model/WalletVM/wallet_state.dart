// lib/blocs/wallet/wallet_state.dart
import 'package:equatable/equatable.dart';
import '../../models/WalletM/wallet_model.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletData walletData;

  const WalletLoaded(this.walletData);

  @override
  List<Object> get props => [walletData];
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object> get props => [message];
}