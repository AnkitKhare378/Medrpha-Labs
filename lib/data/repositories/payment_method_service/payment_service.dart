

import '../../../core/network/api_call.dart';
import '../../../models/PaymentMethodM/payment_method_model.dart';

/// API constant for payment methods. You might want to move this to ApiConstants.
const String _paymentMethodApi = "https://www.online-tech.in/api/PaymentMethod/GetPaymentMethod";

class PaymentService {
  final ApiCall _apiCall = ApiCall();

  /// Fetches the list of payment methods from the API.
  Future<PaymentMethodList> fetchPaymentMethods() async {
    try {
      // Use the static ApiCall.get method
      final responseBody = await ApiCall.get(_paymentMethodApi);

      // Ensure the response is a List<dynamic>
      if (responseBody is List) {
        // Convert the list of JSON objects into the PaymentMethodList model
        return PaymentMethodList.fromListJson(responseBody);
      } else {
        throw Exception("Invalid API response format: Expected a List.");
      }
    } catch (e) {
      // Re-throw or throw a more specific exception for the UI layer to handle
      throw Exception("Failed to load payment methods: ${e.toString()}");
    }
  }
}