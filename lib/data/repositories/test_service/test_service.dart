import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/TestM/lab_test.dart';

class TestService{
  Future<List<LabTest>> fetchAllTests() async {
    try {
      final responseData = await ApiCall.get(ApiConstants.getAllTests);

      if(responseData is List) {
        return responseData 
            .map((json) => LabTest.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw const FormatException("Invalid response format from API.");
      }
    }
    catch (e){
      rethrow;
    }
  }
}