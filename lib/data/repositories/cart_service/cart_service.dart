import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/CartM/add_to_cart_response.dart';

class CartService {
  Future<AddToCartResponse> addToCart({
    required int userId,
    required int productId,
    required int categoryId,
    required int quantity,
    required double price,
    required double discount,
    String coupon = "",
  }) async {
    final body = {
      "userId": userId,
       "categoryId": categoryId,
      "productId": productId,
      "totalQuantity": quantity, // Always sends one as per requirement
      "price": price,
      "discount": discount,
      "coupon": coupon,
    };

    final jsonResponse = await ApiCall.post(ApiConstants.addToCart, body);

    return AddToCartResponse.fromJson(jsonResponse);
  }
}