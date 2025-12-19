

import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/AddressM/get_user_address_by_id_model.dart';

class GetUserAddressByIdService {
  Future<GetUserAddressByIdModel> fetchUserAddressById(String addressId) async {
    final url = '${ApiConstants.baseUrl}Customer/GetUserAddressById/$addressId';

    try {
      final responseBody = await ApiCall.get(url);

      if (responseBody is Map<String, dynamic>) {
        return GetUserAddressByIdModel.fromJson(responseBody);
      } else {
        throw Exception("Invalid response format from API.");
      }
    } catch (e) {
      // Re-throw the exception to be caught by the BLoC/ViewModel
      throw Exception("Failed to fetch address details: ${e.toString()}");
    }
  }
}