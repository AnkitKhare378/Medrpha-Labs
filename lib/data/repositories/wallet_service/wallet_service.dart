import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/WalletM/wallet_model.dart';

class WalletService {
  Future<WalletResponse> fetchWalletData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('user_id') ?? 0;
      final url = "${ApiConstants.baseUrl}WalletAPI/GetWalletByCustomerId?customerId=$customerId";
      final responseBody = await ApiCall.get(url);
      if (responseBody != null) {
        final walletResponse = WalletResponse.fromJson(responseBody);
        if (walletResponse.succeeded && walletResponse.data != null) {
          return walletResponse;
        } else {
          throw Exception(walletResponse.message ?? 'Failed to fetch wallet data.');
        }
      } else {
        throw Exception('API response body was null.');
      }
    } catch (e) {
      throw Exception('Wallet API call failed: ${e.toString()}');
    }
  }
}