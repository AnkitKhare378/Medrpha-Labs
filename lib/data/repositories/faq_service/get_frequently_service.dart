

import '../../../core/network/api_call.dart';
import '../../../models/FaqM/get_frequently_model.dart';

class FrequentlyService {
  static const String faqApi = "https://online-tech.in/api/Rating/GetAllFrequently";

  Future<List<FrequentlyModel>> fetchFaqs() async {
    try {
      final response = await ApiCall.get(faqApi);

      // The API returns a List of Maps
      if (response is List) {
        return response
            .map((json) => FrequentlyModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Invalid response format from FAQ API.");
      }
    } catch (e) {
      // Re-throw the exception to be handled by the BLoC
      throw Exception("Failed to load FAQs: $e");
    }
  }
}