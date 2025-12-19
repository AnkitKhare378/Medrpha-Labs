import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/AddressM/user_address_insert_model.dart';

class UserAddressInsertService {
  static const String _insertAddressUrl = "${ApiConstants.baseUrl}Customer/UserAddressesInsert";

  Future<UserAddressInsertResponse> insertUserAddress(
      UserAddressInsertRequest request) async {
    try {
      final jsonBody = request.toJson();

      // Use the existing ApiCall.post method
      final responseJson = await ApiCall.post(_insertAddressUrl, jsonBody);

      // Assuming the response is successful (status 200) and contains the data
      return UserAddressInsertResponse.fromJson(responseJson);

    } catch (e) {
      // Re-throw the exception, possibly after logging or wrapping it
      throw Exception("Failed to insert address: ${e.toString()}");
    }
  }
}