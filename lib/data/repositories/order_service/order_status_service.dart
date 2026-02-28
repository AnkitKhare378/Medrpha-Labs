import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/OrderM/order_status_model.dart';

class OrderStatusService {
  Future<OrderStatusUpdateResponse> updateOrderStatus({
    required int orderId,
    required int statusType,
    required String orderDate,
    required String orderTime,
  }) async {
    // URL no longer contains the sensitive data parameters
    final url = "${ApiConstants.baseUrl}Order/OrderCancle";

    // Prepare the raw body map
    final Map<String, dynamic> body = {
      "orderId": orderId,
      "statusType": statusType,
      "status": true,
      "orderDate": orderDate,
      "orderTime": orderTime
    };

    try {
      // Switched from ApiCall.get to ApiCall.post
      final jsonResponse = await ApiCall.post(url, body);

      return OrderStatusUpdateResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }
}