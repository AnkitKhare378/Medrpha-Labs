import '../../../../config/apiConstant/api_constant.dart'; // Adjust path
import '../../../../core/network/api_call.dart';
import '../../../models/FamilyMemberM/relation_model.dart';

class RelationService {
  static const String _apiUrl = '${ApiConstants.baseUrl}MasterAPI/GetAllRelations';

  Future<List<RelationModel>> getAllRelations() async {
    final jsonResponse = await ApiCall.get(_apiUrl);

    if (jsonResponse is List) {
      return jsonResponse
          .map((item) => RelationModel.fromJson(item as Map<String, dynamic>))
          .where((relation) => relation.isActive)
          .toList();
    } else {
      throw Exception('Invalid response format: Expected a list of relations.');
    }
  }
}