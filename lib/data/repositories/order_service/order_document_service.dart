import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/OrderM/order_document_model.dart';

class OrderDocumentService {
  Future<OrderDocumentResponse> getOrderDocument(int orderId) async {
    try {
      final response = await ApiCall.get(
          "${ApiConstants.baseUrl}Order/GetOrderDocumentById?orderId=$orderId"
      );
      return OrderDocumentResponse.fromJson(response);
    } catch (e) {
      throw Exception("Failed to fetch document: $e");
    }
  }
}