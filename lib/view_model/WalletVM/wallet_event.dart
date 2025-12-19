// lib/blocs/wallet/wallet_event.dart
import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class FetchWalletData extends WalletEvent {
  const FetchWalletData();
}