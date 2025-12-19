import 'package:medrpha_labs/config/apiConstant/api_constant.dart';
import 'package:medrpha_labs/core/network/api_call.dart';
import '../../../models/FamilyMemberM/family_member_delete_model.dart';

class FamilyMemberDeleteService {

  static const String _path = 'Customer/FamilyMemberDelete/';

  Future<FamilyMemberDeleteModel> deleteMember(int memberId) async {
    final url = '${ApiConstants.baseUrl}$_path$memberId';

    try {
      // The API uses a GET endpoint for the delete operation.
      final responseJson = await ApiCall.get(url);

      // Check for success property in the response body if available
      if (responseJson['succeeded'] == true) {
        return FamilyMemberDeleteModel.fromJson(responseJson);
      } else {
        // Throw an exception with the error message from the API
        throw Exception(responseJson['message'] ?? 'Failed to delete member.');
      }
    } catch (e) {
      // Re-throw any network or parsing exception
      rethrow;
    }
  }
}