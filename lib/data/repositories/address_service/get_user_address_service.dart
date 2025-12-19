import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart'; // Assuming ApiCall is here
import '../../../models/AddressM/get_address_model.dart';

class GetUserAddressService {
  Future<List<UserAddress>> fetchUserAddresses(String userId) async {
    final url = "${ApiConstants.getUserAddress}/$userId";

    final responseData = await ApiCall.get(url);

    if (responseData is List) {
      // The API returns a list of JSON objects
      return List<UserAddress>.from(
        responseData.map((item) => UserAddress.fromJson(item)),
      );
    } else {
      // Handle non-list responses (e.g., empty or error)
      throw Exception("Invalid response format for user addresses.");
    }
  }
}