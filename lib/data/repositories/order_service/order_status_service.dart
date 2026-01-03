

import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/OrderM/order_status_model.dart';

class OrderStatusService {
  Future<OrderStatusUpdateResponse> updateOrderStatus({
    required int orderId,
    required int statusType,
  }) async {
    final url =
        "${ApiConstants.baseUrl}Order/OrderCancle?orderId=$orderId&statusType=$statusType&status=true";

    try {
      final jsonResponse = await ApiCall.get(url);

      return OrderStatusUpdateResponse.fromJson(jsonResponse);
    } catch (e) {
      // Re-throw the exception to be caught by the BLoC
      throw Exception('Failed to update order status: $e');
    }
  }
}