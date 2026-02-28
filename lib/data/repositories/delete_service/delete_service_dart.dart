// file: lib/data/repositories/cart_service/delete_cart_service.dart

import '../../../config/apiConstant/api_constant.dart'; // Ensure correct path
import '../../../core/network/api_call.dart'; // Ensure correct path
import '../../../models/CartM/delete_cart_model.dart';

class DeleteCartService {
  Future<DeleteCartResponse> deleteCart(int cartId) async {
    // 1. Remove the ID from the URL string
    final String url = "${ApiConstants.baseUrl}MasterAPI/DeleteCart";

    // 2. Create the body map
    final Map<String, dynamic> body = {
      "cardId": cartId, // Ensure the key matches what your backend expects
    };

    try {
      // 3. Change .get() to .post() and pass the body
      final response = await ApiCall.post(url, body);
      return DeleteCartResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}