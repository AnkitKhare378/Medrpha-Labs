

import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/PackagesM/package_detail_model.dart';

class PackageDetailService {
  static const String _packageDetailEndpoint = "MasterAPI/TestPackagesById";

  Future<PackageDetailModel> getPackageDetail(int packageId) async {
    final url =
        "${ApiConstants.baseUrl}$_packageDetailEndpoint?PackageId=$packageId";

    try {
      final response = await ApiCall.get(url);

      // We expect the 'data' field to be a list containing a single package object.
      if (response is Map<String, dynamic> &&
          response['succeeded'] == true &&
          response['data'] is List &&
          (response['data'] as List).isNotEmpty) {

        final packageData = (response['data'] as List).first;
        return PackageDetailModel.fromJson(packageData as Map<String, dynamic>);
      } else {
        throw Exception("Invalid or empty package data received for PackageId: $packageId");
      }
    } catch (e) {
      rethrow;
    }
  }
}