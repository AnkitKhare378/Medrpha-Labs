

import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/TestM/lab_test.dart';

class TestSearchService {
  static const String _searchTests = "${ApiConstants.baseUrl}Lab/TestSearch";

  /// Performs a search for lab tests based on parameters.
  Future<List<LabTest>> searchTests({
    required String name,
    required int labId,
    required int symptomId,
  }) async {
    final body = {
      "name": name,
      "labId": labId,
      "symptomId": symptomId,
    };

    try {
      final responseData = await ApiCall.post(_searchTests, body);

      if (responseData is List) {
        return responseData
            .map((json) => LabTest.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw const FormatException("Invalid response format from API.");
      }
    } catch (e) {
      // Re-throw the exception to be handled by the Cubit/ViewModel
      rethrow;
    }
  }
}