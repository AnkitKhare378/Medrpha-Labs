import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/WishlistM/wishlist_response_model.dart';

class WishlistService {
  Future<WishlistResponseModel> toggleWishlist(
      int userId,
      int productId,
      int categoryId,
      ) async {
    const url = ApiConstants.insertWishlist;
    final body = {
      "userId": userId,
      "productId": productId,
      "categoryId": categoryId,
    };

    try {
      final jsonResponse = await ApiCall.post(url, body);
      return WishlistResponseModel.fromJson(jsonResponse);
    } catch (e) {
      //
      rethrow;
    }
  }
}