// lib/view_model/UpdateWalletVM/update_wallet_view_model.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/wallet_service/update_wallet_service.dart';
import '../../../models/WalletM/wallet_update_model.dart';
import 'update_wallet_event.dart';
import 'update_wallet_state.dart';

// Renamed from WalletBloc to UpdateWalletViewModel to better reflect the purpose
class UpdateWalletViewModel extends Bloc<UpdateWalletEvent, UpdateWalletState> {
  final UpdateWalletService _updateWalletService;

  UpdateWalletViewModel(this._updateWalletService)
      : super(UpdateWalletInitial()) {
    on<AddBalanceToWallet>(_onAddBalanceToWallet);
  }

  void _onAddBalanceToWallet(
      AddBalanceToWallet event, Emitter<UpdateWalletState> emit) async {
    // 1. Set isLoding = true
    emit(UpdateWalletLoading());

    try {
      final requestModel = UpdateWalletRequestModel(
        userId: event.userId,
        currentBalance: event.amountToAdd,
      );

      // 2. Call the update service
      final response =
      await _updateWalletService.updateWalletBalance(requestModel);

      // 3. Emit success state with the new balance
      emit(UpdateWalletSuccess(response.data.currentBalance));

      print("✅ Wallet Update Success: ${response.message}");

    } catch (e) {
      // 4. Emit error state
      emit(UpdateWalletError(e.toString()));
      print("❌ Wallet Update Error: $e");
    }
  }
}