import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/BrandM/brand_model.dart';

class BrandService {
  final String _brandsUrl = '${ApiConstants.baseUrl}MasterAPI/GetAllBrands';

  Future<List<BrandModel>> fetchAllBrands() async {
    try {
      final response = await ApiCall.get(_brandsUrl);

      if (response is List) {
        return response
            .map((json) => BrandModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw const FormatException('Invalid response format. Expected a list.');
      }
    } catch (e) {
      rethrow;
    }
  }
}