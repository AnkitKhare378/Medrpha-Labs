// lib/services/RatingS/rating_delete_service.dart

import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/RatingM/rating_delete_model.dart';

class RatingDeleteService {

  static const String _baseUrl = "${ApiConstants.baseUrl}Rating/RatingDelete";

  Future<RatingDeleteResponseModel> deleteRating({
    required int ratingId,
  }) async {
    final String deleteUrl = "$_baseUrl?Id=$ratingId";

    try {
      final responseData = await ApiCall.get(deleteUrl);

      final responseModel = RatingDeleteResponseModel.fromJson(responseData);

      if (responseModel.succeeded) {
        return responseModel;
      } else {
        // Throw exception using messages from the API response, or a default message
        final errorMessage = responseModel.messages.isNotEmpty
            ? responseModel.messages.join(', ')
            : 'Failed to delete rating.';

        throw Exception(errorMessage);
      }
    } catch (e) {
      // Re-throw the network or API error
      rethrow;
    }
  }
}