

import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/LabM/lab_model.dart';

class LabService {
  final String labApiUrl = "${ApiConstants.baseUrl}Lab";

  Future<List<LabModel>> fetchLabs() async {
    try {
      final responseData = await ApiCall.get(labApiUrl);

      // responseData is expected to be a List<dynamic> (JSON array)
      if (responseData is List) {
        return responseData.map((json) => LabModel.fromJson(json)).toList();
      } else {
        throw Exception("Invalid API response format");
      }
    } catch (e) {
      // Re-throw the exception for the BLoC/ViewModel to handle
      rethrow;
    }
  }
}