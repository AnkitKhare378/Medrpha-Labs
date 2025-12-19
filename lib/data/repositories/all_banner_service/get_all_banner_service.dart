import 'package:medrpha_labs/config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/BannerM/get_all_banner_model.dart';

class GetAllBannerService {
  static const String _apiEndpoint =
      "${ApiConstants.baseUrl}Rating/GetAllBanner";

  /// Fetches all banners from the API.
  Future<List<GetAllBannerModel>> fetchAllBanners() async {
    try {
      // The ApiCall.get method handles the network request, status code check,
      // and JSON decoding. It returns the decoded body (dynamic).
      final dynamic responseData = await ApiCall.get(_apiEndpoint);

      // The API returns a list of objects.
      if (responseData is List) {

        return responseData
            .map((json) => GetAllBannerModel.fromJson(json))
            .toList();
      } else {
        // Handle unexpected response format
        throw Exception(
            "Invalid response format from API: Expected a List.");
      }
    } catch (e) {
      // Re-throw any exceptions (network error, API error, etc.)
      rethrow;
    }
  }
}