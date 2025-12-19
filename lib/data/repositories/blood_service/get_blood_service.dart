

import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/BloodM/get_blood_model.dart';

class GetBloodGroupService {
  static const String _apiEndpoint = "${ApiConstants.baseUrl}MasterAPI/GetBloodGroups";

  Future<List<GetBloodGroupModel>> fetchBloodGroups() async {
    try {
      final responseData = await ApiCall.get(_apiEndpoint);

      if (responseData is List) {
        // Map the list of JSON objects to a list of GetBloodGroupModel objects
        return responseData
            .map((json) => GetBloodGroupModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw const FormatException("Invalid response format: Expected a list.");
      }
    } catch (e) {
      // Re-throw the exception to be handled by the BLoC
      throw Exception("Failed to fetch blood groups: ${e.toString()}");
    }
  }
}