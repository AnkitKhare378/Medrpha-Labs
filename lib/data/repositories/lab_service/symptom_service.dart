// lib/data/repositories/symptom_service/symptom_service.dart
import '../../../config/apiConstant/api_constant.dart'; // Ensure this path is correct
import '../../../core/network/api_call.dart';
import '../../../models/LabM/symptom_model.dart'; // Ensure this path is correct

class SymptomService {
  final String symptomApiUrl = ApiConstants.getAllSymptoms;

  Future<List<SymptomModel>> fetchSymptoms() async {
    try {
      final responseData = await ApiCall.get(symptomApiUrl);

      if (responseData is List) {
        return responseData.map((json) => SymptomModel.fromJson(json)).toList();
      } else {
        throw Exception("Invalid API response format for Symptoms");
      }
    } catch (e) {
      rethrow;
    }
  }
}