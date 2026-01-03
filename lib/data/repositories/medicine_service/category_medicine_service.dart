import '../../../core/network/api_call.dart';
import '../../../models/MedicineM/category_medicine_model.dart';

class CategoryMedicineService {
  Future<List<CategoryMedicineModel>> fetchMedicines({
    required int id,
    required MedicineFetchType type,
  }) async {
    try {
      // Determine URL based on type
      final String endpoint = type == MedicineFetchType.category
          ? 'Medicine/GetMedicineByCategory?Id=$id'
          : 'Medicine/GetMedicineByBrand?Id=$id';

      final response = await ApiCall.get('https://online-tech.in/api/$endpoint');

      if (response != null) {
        Iterable list = response;
        return list.map((model) => CategoryMedicineModel.fromJson(model)).toList();
      } else {
        throw Exception("No data found");
      }
    } catch (e) {
      rethrow;
    }
  }
}

enum MedicineFetchType { category, brand }