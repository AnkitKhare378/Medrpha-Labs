import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<PhoneSubmitted>(_onPhoneSubmitted);
  }

  void _onPhoneSubmitted(PhoneSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    await Future.delayed(const Duration(seconds: 1)); // simulate API call
    if (RegExp(r'^[6-9]\d{9}$').hasMatch(event.phoneNumber)) {
      emit(LoginOtpSent(event.phoneNumber));
    } else {
      emit(LoginError("Invalid phone number"));
    }
  }
}
