// File: lib/data/repositories/master_service/relation_service.dart

import '../../../../config/apiConstant/api_constant.dart'; // Adjust path
import '../../../../core/network/api_call.dart';
import '../../../models/FamilyMemberM/relation_model.dart'; // Adjust path

class RelationService {
  static const String _apiUrl = '${ApiConstants.baseUrl}MasterAPI/GetAllRelations';

  /// Fetches the list of all family relations.
  Future<List<RelationModel>> getAllRelations() async {
    final jsonResponse = await ApiCall.get(_apiUrl);

    if (jsonResponse is List) {
      // Filter out inactive relations (optional, but good practice)
      return jsonResponse
          .map((item) => RelationModel.fromJson(item as Map<String, dynamic>))
          .where((relation) => relation.isActive)
          .toList();
    } else {
      throw Exception('Invalid response format: Expected a list of relations.');
    }
  }
}