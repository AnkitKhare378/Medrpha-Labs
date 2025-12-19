import 'package:medrpha_labs/models/MedicineM/get_medicine_by_company_model.dart';
import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';

class GetMedicineByCompanyService {
  Future<List<GetMedicineByCompanyModel>> fetchMedicineByCompany(int companyId) async {
    final url = '${ApiConstants.baseUrl}Medicine/GetMedicineByCompany?CompanyId=$companyId';
    try {
      final responseBody = await ApiCall.get(url);

      // Check if the response is a list (typical for a 'Get by Company' API)
      if (responseBody is List) {
        // Map the list of JSON objects to a list of Model objects
        return responseBody
            .map((json) => GetMedicineByCompanyModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        // Handle cases where the response is not a list (e.g., an empty object or error structure)
        // If it's a success but empty list, we return an empty list.
        if (responseBody is Map<String, dynamic> && responseBody.isEmpty) {
          return [];
        }
        throw Exception("Invalid response format: Expected a List.");
      }
    } catch (e) {
      // Re-throw the exception to be caught by the BLoC/ViewModel
      throw Exception("Failed to fetch medicines: ${e.toString()}");
    }
  }
}