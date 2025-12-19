

import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/TestM/test_detail_model.dart';

class TestDetailService {
  // Define the Test Master endpoint relative to baseUrl
  static const String _testDetailEndpoint =
      "MasterAPI/TestMasterByTestId";

  Future<TestDetailModel> getTestDetail(int testId) async {
    // Construct the full URL
    final url =
        "${ApiConstants.baseUrl}$_testDetailEndpoint?TestId=$testId";

    try {
      final response = await ApiCall.get(url);

      // The API response is a list containing a single object.
      if (response is List && response.isNotEmpty) {
        // We expect the first element to be the TestDetail object.
        return TestDetailModel.fromJson(response[0] as Map<String, dynamic>);
      } else {
        throw Exception("Invalid or empty response from API for TestId: $testId");
      }
    } catch (e) {
      // Re-throw the exception for the ViewModel/Bloc to handle
      rethrow;
    }
  }
}