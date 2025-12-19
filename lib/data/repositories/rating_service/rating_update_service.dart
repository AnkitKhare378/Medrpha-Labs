import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/RatingM/rating_update_model.dart';

class RatingUpdateService {

  static const String _updateUrl = "${ApiConstants.baseUrl}Rating/RatingUpdate";

  Future<RatingUpdateResponseModel> updateRating({
    required int ratingId,
    required String remark,
    required int ratingPoint,
    required int categoryId,
    required int productId,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final int? userId = prefs.getInt('user_id');

    if (userId == null) {
      throw Exception('User ID not found in SharedPreferences.');
    }

    final Map<String, dynamic> body = {
      "ratingId": ratingId,
      "remark": remark,
      "ratingpoint": ratingPoint,
      "userId": userId,
      "categoryId": categoryId,
      "productId": productId,
    };

    try {
      final responseData = await ApiCall.post(_updateUrl, body);
      final responseModel = RatingUpdateResponseModel.fromJson(responseData);

      if (responseModel.succeeded) {
        return responseModel;
      } else {
        throw Exception(responseModel.message);
      }
    } catch (e) {
      rethrow;
    }
  }
}