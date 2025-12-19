

import '../../../core/network/api_call.dart';
import '../../../models/RatingM/get_rating_model.dart';

class GetRatingService {
  static const String _apiBaseUrl = "https://www.online-tech.in/api/Rating/GetRatingDetail";

  Future<List<RatingDetailModel>> getRatingDetails({
    required int categoryId,
    required int productId,
  }) async {
    // Construct the full URL with query parameters
    final url = '$_apiBaseUrl?CategoryId=$categoryId&ProductId=$productId';

    try {
      // Execute the API GET request
      final dynamic responseData = await ApiCall.get(url);

      // The response is a List of JSON objects
      if (responseData is List) {
        // Map the list of JSON objects to a list of RatingDetailModel instances
        return responseData.map((json) => RatingDetailModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        // Handle unexpected response format (e.g., if the API returns an empty object or error)
        return [];
      }
    } catch (e) {
      // Re-throw the exception caught by ApiCall or any parsing error
      rethrow;
    }
  }
}