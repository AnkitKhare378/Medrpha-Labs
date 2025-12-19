import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc() : super(OtpInitial()) {
    on<OtpSubmitted>(_onOtpSubmitted);
  }

  void _onOtpSubmitted(OtpSubmitted event, Emitter<OtpState> emit) async {
    emit(OtpVerifying());
    await Future.delayed(const Duration(seconds: 1)); // simulate API
    if (event.otp == "123456") {
      emit(OtpVerified());
    } else {
      emit(OtpError("Invalid OTP"));
    }
  }
}
