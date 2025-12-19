import '../../config/apiConstant/api_constant.dart';
import '../../core/network/api_call.dart';
import '../../models/AccountM/login_model.dart';

class LoginService {
  Future<LoginModel> login({String? phone, String? email}) async {
    String url = ApiConstants.login;

    if (phone != null && phone.isNotEmpty) {
      url += "?phoneNumber=$phone";
    } else if (email != null && email.isNotEmpty) {
      url += "?emailId=$email";
    } else {
      throw Exception("Phone or email is required");
    }

    // ✅ Use POST instead of GET — no body needed
    final response = await ApiCall.post(url, {});
    return LoginModel.fromJson(response);
  }
}
