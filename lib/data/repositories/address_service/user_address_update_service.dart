import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/AddressM/user_address_insert_model.dart';

class UserAddressUpdateService {
  Future<UserAddressUpdateResponse> updateAddress(UserAddressUpdateRequest request) async {
    final url = ApiConstants.updateAddress;

    // The API request body
    final body = request.toJson();

    try {
      final responseData = await ApiCall.post(url, body);

      return UserAddressUpdateResponse.fromJson(responseData);

    } catch (e) {
      rethrow;
    }
  }
}