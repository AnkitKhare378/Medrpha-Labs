import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/OrderM/order_response_model.dart';

class OrderService {
  final String _createOrderUrl = "${ApiConstants.baseUrl}Order/CreateOrder";

  /// Sends the order details to the API to finalize the purchase.
  Future<OrderResponseModel> createOrder({
    required int userId,
    required int userAddressId,
    required int cartId,
    required int paymentMethod,
    required double subTotal,
    required double discountAmount,
    required double finalAmount,
    required String orderTime,
    required String orderDate
  }) async {
    final body = {
      "userId": userId,
      "cartId": cartId,
      "userAddressId": userAddressId,
      "orderNumber": "", // API expects an empty string initially
      "orderStatus": 1, // Defaulting to "Pending" or equivalent
      "paymentStatus": 1, // Defaulting to "Pending" or equivalent
      "paymentMethod": paymentMethod,
      "subTotal": subTotal,
      "discountAmount": discountAmount,
      "finalAmount": finalAmount,
      "orderTime": orderTime,
      "orderDate": orderDate,
    };

    try {
      final response = await ApiCall.post(_createOrderUrl, body);
      return OrderResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}