import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/CartM/get_cart_model.dart';

class GetCartService {
  final String _getCartEndpoint =
      "${ApiConstants.baseUrl}MasterAPI/GetCartByUserId";

  /// Fetches the user's cart data from the API.
  Future<GetCartResponse> getCart(int userId) async {
    final url = '$_getCartEndpoint?userId=$userId';

    try {
      final Map<String, dynamic> jsonResponse = await ApiCall.get(url);

      final response = GetCartResponse.fromJson(jsonResponse);

      if (response.succeeded) {
        return response;
      } else {
        // Throw an exception with the message from the API if it failed
        throw Exception(
            response.message ?? 'Failed to fetch cart data from API.');
      }
    } catch (e) {
      // Re-throw the exception for the BLoC to handle
      throw Exception('Cart API error: $e');
    }
  }
}