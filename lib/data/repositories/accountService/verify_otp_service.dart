import '../../../config/apiConstant/api_constant.dart';
import '../../../core/network/api_call.dart';
import '../../../models/AccountM/verify_otp_model.dart';

class VerifyOtpService {
  static Future<VerifyOtpModel> verifyOtp({
    required String input,
    required String otp,
    required String deviceToken,
    required String deviceType,
  }) async {
    final bool isNumeric = RegExp(r'^[0-9]+$').hasMatch(input);
    final String url = isNumeric
        ? "${ApiConstants.baseUrl}Auth/VerifyOtp?phoneNumber=$input&otp=$otp&deviceToken=$deviceToken&deviceType=$deviceType"
        : "${ApiConstants.baseUrl}Auth/VerifyOtp?emailId=$input&otp=$otp&deviceToken=$deviceToken&deviceType=$deviceType";

    final response = await ApiCall.post(url, {});
    return VerifyOtpModel.fromJson(response);
  }
}
