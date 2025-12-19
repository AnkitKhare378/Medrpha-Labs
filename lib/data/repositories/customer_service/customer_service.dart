import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/CustomerM/customer_model.dart';

class CustomerService {
  static const String _apiPath = "MasterAPI/GetCustomersById?id=";

  Future<CustomerResponse> fetchCustomerById(int customerId) async {
    final url = "${ApiConstants.baseUrl}$_apiPath$customerId";

    try {
      final responseJson = await ApiCall.get(url);

      if (responseJson != null) {
        return CustomerResponse.fromJson(responseJson);
      }

      throw Exception("Invalid response format from API");

    } catch (e) {
      // Re-throw the exception to be handled by the BLoC
      rethrow;
    }
  }
}