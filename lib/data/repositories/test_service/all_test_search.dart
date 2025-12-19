

import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/TestM/test_search_model.dart';

class AllTestSearchService {
  static const String _testSearchUrl =
      "${ApiConstants.baseUrl}MasterAPI/TestSearchMaster";

  /// Fetches test search results based on the query string.
  Future<List<TestSearchModel>> searchTests(String searchText) async {
    // Construct the full API URL with the query parameter
    final url = '$_testSearchUrl?SearchText=$searchText';

    try {
      final dynamic responseData = await ApiCall.get(url);

      // The API returns a List<Map<String, dynamic>>
      if (responseData is List) {
        return responseData
            .map((json) => TestSearchModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      // Handle unexpected response format (e.g., if it's an empty list or null)
      return [];
    } catch (e) {
      // Re-throw to be handled by the BLoC
      rethrow;
    }
  }
}