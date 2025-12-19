import 'package:medrpha_labs/config/apiConstant/api_constant.dart';
import 'package:medrpha_labs/models/MedicineM/get_medicine_by_id_model.dart';
import '../../../core/network/api_call.dart';

class MedicineService {
  Future<GetMedicineByIdModel> getMedicineById(int id) async {
    final url = '${ApiConstants.baseUrl}Medicine/GetMedicineById?Id=$id';
    try {
      final responseData = await ApiCall.get(url);
      final model = GetMedicineByIdModel.fromJson(responseData);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
