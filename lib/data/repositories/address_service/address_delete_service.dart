import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/AddressM/delete_address_model.dart';

class AddressDeleteService {

  Future<DeleteAddressModel> deleteAddress({required String addressId}) async {
    final String url = '${ApiConstants.deleteUserAddress}?id=$addressId';

    try {
      final responseData = await ApiCall.get(url);

      // Check if the API response indicates success
      if (responseData['succeeded'] == true) {
        return DeleteAddressModel.fromJson(responseData);
      } else {
        // Throw an exception with a custom message from the API if available
        final errorMessage = responseData['message'] as String? ?? 'Failed to delete address.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Re-throw any network or parsing error
      throw Exception('Failed to delete address: ${e.toString()}');
    }
  }
}