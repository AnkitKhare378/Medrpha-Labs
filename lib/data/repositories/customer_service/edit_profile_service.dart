import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/CustomerM/update_customer_response_model.dart';

class EditProfileService {
  final String _updateCustomerEndpoint = "${ApiConstants.baseUrl}MasterAPI/UpdateCustomer";

  Future<UpdateCustomerResponse> updateCustomer({
    required int id,
    required String customerName,
    required String emailId,
    required String phoneNumber,
    required String dob,
    required String bloodGroup,
    required String gender,
    String? photoPath,
  }) async {
    final Map<String, String> fields = {
      'Id': id.toString(),
      'CustomerName': customerName,
      'EmailId': emailId,
      'PhoneNumber': phoneNumber,
      'DOB': dob,
      'BloodGroup': bloodGroup,
      'Gender': gender,
    };

    try {
      final responseData = await ApiCall.postMultipart(
        _updateCustomerEndpoint,
        fields,
        filePath: photoPath,
        fileField: 'UploadPhoto',
      );

      // 2. Map the response data to the model
      return UpdateCustomerResponse.fromJson(responseData);
    } catch (e) {
      print("Error updating customer profile: $e");
      rethrow;
    }
  }
}