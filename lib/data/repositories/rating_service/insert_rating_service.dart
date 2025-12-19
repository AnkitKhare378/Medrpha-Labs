import 'package:medrpha_labs/config/apiConstant/api_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_call.dart';
import '../../../models/RatingM/insert_rating_model.dart';

class InsertRatingService {
  static const String _userIdKey = 'user_id';

  Future<InsertRatingResponse> insertRating({
    required String remark,
    required int ratingpoint,
    required int categoryId,
    required int productId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_userIdKey);

    if (userId == null) {
      throw Exception("User ID not found in local storage. Cannot submit rating.");
    }
    final request = InsertRatingRequest(
      remark: remark,
      ratingpoint: ratingpoint,
      userId: userId,
      categoryId: categoryId,
      productId: productId,
    );

    final requestBody = request.toJson();

    try {
      final dynamic responseData = await ApiCall.post(ApiConstants.insertRating, requestBody);
      return InsertRatingResponse.fromJson(responseData);
    } catch (e) {
      rethrow;
    }
  }
}