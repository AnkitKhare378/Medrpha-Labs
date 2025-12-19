

import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/SynonymsM/test_synonyms_model.dart';

class TestSynonymsService {
  static const String _synonymsEndpoint = "MasterAPI/TestSynonymsByTestId";

  Future<List<TestSynonymModel>> fetchTestSynonyms(int testId) async {
    final url = "${ApiConstants.baseUrl}$_synonymsEndpoint?TestId=$testId";

    try {
      final response = await ApiCall.get(url);

      // The response body is a List of Maps directly
      if (response is List) {
        return response
            .map((item) => TestSynonymModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        // Handle cases where the API returns a success message instead of a list
        return [];
      }
    } catch (e) {
      // Re-throw the exception handled by ApiCall (network or HTTP error)
      rethrow;
    }
  }
}