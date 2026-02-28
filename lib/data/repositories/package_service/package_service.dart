// need to update 0 to a parameter labId

import 'package:medrpha_labs/config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/PackagesM/package_model.dart';

class PackageService {
  // Remove the static '0' from the base string
  static const String _baseUrl = "${ApiConstants.baseUrl}Package?id=";

  Future<List<PackageModel>> fetchPackages(int labId) async {
    try {
      // Construct URL with the passed labId
      final jsonList = await ApiCall.get("$_baseUrl$labId");

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