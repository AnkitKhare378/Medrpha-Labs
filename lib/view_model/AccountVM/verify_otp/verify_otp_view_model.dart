import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/repositories/accountService/verify_otp_service.dart';
import 'verify_otp_event.dart';
import 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  VerifyOtpBloc() : super(VerifyOtpInitial()) {
    on<VerifyOtpSubmitted>(_onVerifyOtpSubmitted);
  }

  Future<void> _onVerifyOtpSubmitted(
      VerifyOtpSubmitted event, Emitter<VerifyOtpState> emit) async {
    emit(VerifyOtpLoading());
    try {
      final response = await VerifyOtpService.verifyOtp(
        input: event.input,
        otp: event.otp, deviceToken: event.deviceToken, deviceType: 'Android',
      );

      if (response.succeeded) {
        if (response.data?.id != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('user_id', response.data!.id!);
          print("✅ Saved user_id: ${response.data!.id}");
        }

        emit(VerifyOtpSuccess(response));
      } else {
        emit(VerifyOtpError(response.message ?? "Invalid OTP"));
      }
    } catch (e) {
      emit(VerifyOtpError(e.toString()));
    }
  }
}
