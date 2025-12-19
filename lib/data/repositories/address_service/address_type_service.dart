

import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/AddressM/address_type_model.dart';

class AddressTypeService {
  Future<List<AddressTypeModel>> fetchAddressTypes() async {
    final response = await ApiCall.get(ApiConstants.getAddressType);

    if (response is List) {
      return response.map((e) => AddressTypeModel.fromJson(e)).toList();
    } else {
      throw Exception("Invalid response format");
    }
  }
}
