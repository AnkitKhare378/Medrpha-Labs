
import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/WishlistM/wishlist_model.dart';

class GetWishlistService {
  final String baseUrl = ApiConstants.baseUrl;

  /// Fetches the user's wishlist items by User ID.
  Future<List<WishlistItem>> getWishlist(int userId) async {
    // API: https://www.online-tech.in/api/WishlistAPI/GetWishlistById?id=5
    final url = '${baseUrl}WishlistAPI/GetWishlistById?id=$userId';

    try {
      final jsonResponse = await ApiCall.get(url);

      if (jsonResponse is List) {
        // Map the list of JSON objects to a list of WishlistItem objects.
        return jsonResponse.map((json) => WishlistItem.fromJson(json)).toList();
      }

      // If the API returns a non-list response (e.g., an error object)
      throw Exception("Invalid response format from wishlist API.");

    } catch (e) {
      // Re-throw the exception for the BLoC to handle
      rethrow;
    }
  }

// NOTE: You would typically add remove/add to wishlist methods here too.
}