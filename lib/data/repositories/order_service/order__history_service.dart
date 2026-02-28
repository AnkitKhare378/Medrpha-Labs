import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/OrderM/order_history.dart';

class SharedPreferencesUtil {
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') ?? 55;
  }
}

class OrderHistoryService {
  final String _showOrderEndpoint = "${ApiConstants.baseUrl}Order/ShowOrder";

  Future<List<OrderHistoryModel>> fetchOrderHistory({
    required int userId,
    int? orderId,
    String? status,    // Added status filter
    String? timeFrame, // Added time filter
  }) async {
    try {
      final apiOrderId = orderId ?? 0;

      // 1. Start with base parameters
      StringBuffer urlBuffer = StringBuffer('$_showOrderEndpoint?userId=$userId&orderId=$apiOrderId');

      // 2. Append Status Filter if selected
      if (status != null && status.isNotEmpty) {
        urlBuffer.write('&status=${Uri.encodeComponent(status)}');
      }

      // 3. Append Time Filter if selected
      if (timeFrame != null && timeFrame.isNotEmpty) {
        // If your API accepts the string directly (e.g., "2024")
        urlBuffer.write('&timeFrame=${Uri.encodeComponent(timeFrame)}');

        /* NOTE: If your API needs specific date ranges instead of strings,
        you can use a helper like this:
        final dateRange = _mapTimeFrame(timeFrame);
        urlBuffer.write('&startDate=${dateRange['start']}&endDate=${dateRange['end']}');
        */
      }

      final url = urlBuffer.toString();
      final responseData = await ApiCall.get(url);

      if (responseData != null && responseData['data'] is List) {
        final List<dynamic> ordersJson = responseData['data'];
        return ordersJson
            .map((json) => OrderHistoryModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Invalid response format from API.");
      }
    } catch (e) {
      print("Error fetching orders: $e");
      rethrow;
    }
  }

  // Optional Helper: Convert UI text to Date strings if your backend requires it
  Map<String, String> _mapTimeFrame(String timeFrame) {
    DateTime now = DateTime.now();
    if (timeFrame == 'Last 30 days') {
      return {
        'start': now.subtract(const Duration(days: 30)).toIso8601String(),
        'end': now.toIso8601String(),
      };
    } else if (RegExp(r'^\d{4}$').hasMatch(timeFrame)) { // For "2024", "2023"
      return {
        'start': '$timeFrame-01-01',
        'end': '$timeFrame-12-31',
      };
    }
    return {};
  }
}