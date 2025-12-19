

import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/WalletM/wallet_update_model.dart';

class UpdateWalletService {
  final String _updateWalletUrl =
      '${ApiConstants.baseUrl}WalletAPI/UpdateWalletBalance';

  /// Calls the API to update the wallet balance.
  /// [requestModel] contains the userId and the amount to add/update.
  Future<UpdateWalletResponseModel> updateWalletBalance(
      UpdateWalletRequestModel requestModel) async {
    try {
      final responseData =
      await ApiCall.post(_updateWalletUrl, requestModel.toJson());

      if (responseData != null) {
        return UpdateWalletResponseModel.fromJson(responseData);
      }
      throw Exception("Failed to decode update wallet response.");
    } catch (e) {
      // Re-throw the exception to be caught by the BLoC
      rethrow;
    }
  }
}