import '../../../core/network/api_call.dart';
import '../../../models/CompanyM/company_model.dart';

class CompanyService {
  Future<List<CompanyModel>> getAllCompanies() async {
    const String url = "https://online-tech.in/api/Lab/GetAllCompany";

    try {
      final response = await ApiCall.get(url);
      // Since response is a List [...]
      return (response as List)
          .map((item) => CompanyModel.fromJson(item))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}