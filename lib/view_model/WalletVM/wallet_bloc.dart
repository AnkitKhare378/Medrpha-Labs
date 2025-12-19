// lib/blocs/wallet/wallet_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/wallet_service/wallet_service.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletService walletService;

  WalletBloc({required this.walletService}) : super(WalletInitial()) {
    on<FetchWalletData>(_onFetchWalletData);
  }

  void _onFetchWalletData(
      FetchWalletData event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    try {
      final response = await walletService.fetchWalletData();
      if (response.data != null) {
        emit(WalletLoaded(response.data!));
      } else {
        emit(const WalletError('Wallet data not found.'));
      }
    } catch (e) {
      emit(WalletError('Failed to load wallet: ${e.toString()}'));
    }
  }
}