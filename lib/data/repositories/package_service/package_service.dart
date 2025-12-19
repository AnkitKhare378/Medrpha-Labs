import '../../../core/network/api_call.dart';
import '../../../models/PackagesM/package_model.dart';

class PackageService {
  static const String packageApiUrl = "https://www.online-tech.in/api/Package?id=1";

  Future<List<PackageModel>> fetchPackages() async {
    try {
      final jsonList = await ApiCall.get(packageApiUrl);

      if (jsonList is List) {
        return jsonList.map((json) => PackageModel.fromJson(json)).toList();
      } else {
        throw Exception("Invalid response format from package API.");
      }
    } catch (e) {
      rethrow;
    }
  }
}