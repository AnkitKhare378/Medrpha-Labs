import '../../../core/network/api_call.dart';
import '../../../models/MedicineM/store_medicine_model.dart';

class GetMedicineByStoreService {
  Future<List<StoreMedicineModel>> fetchMedicinesByStore(int storeId) async {
    try {
      final response = await ApiCall.get(
        "https://online-tech.in/api/Medicine/GetMedicineByStore?store=$storeId",
      );

      if (response is List) {
        return response.map((json) => StoreMedicineModel.fromJson(json)).toList();
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      rethrow;
    }
  }
}