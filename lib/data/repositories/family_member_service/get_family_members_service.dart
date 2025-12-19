import '../../../config/apiConstant/api_constant.dart'; // Adjust path as needed
import '../../../core/network/api_call.dart'; // Adjust path as needed
import '../../../models/FamilyMemberM/get_family_members_model.dart';

class GetFamilyMembersService {
  static const String _apiBaseUrl =
      '${ApiConstants.baseUrl}Customer/GetFamilyMemberByUserId/';

  Future<List<FamilyMemberModel>> getMembers(String userId) async {
    final String url = '$_apiBaseUrl$userId';

    final jsonResponse = await ApiCall.get(url);

    if (jsonResponse is List) {
      return jsonResponse
          .map((item) => FamilyMemberModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Invalid response format: Expected a list of family members.');
    }
  }
}