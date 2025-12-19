// lib/viewmodel/login_view_model.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/login_service.dart';
import '../../models/AccountM/login_model.dart';

// ---------- EVENTS ----------
abstract class LoginEvent {}

class LoginRequested extends LoginEvent {
  final String input; // can be phone or email
  LoginRequested(this.input);
}

// ---------- STATES ----------
abstract class LoginState {}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final LoginModel loginData;
  LoginSuccess(this.loginData);
}
class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}

// ---------- BLOC ----------
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginService _loginService;

  LoginBloc(this._loginService) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      if (RegExp(r'^[0-9]+$').hasMatch(event.input)) {
        // Phone number
        final data = await _loginService.login(phone: event.input);
        emit(LoginSuccess(data));
      } else {
        // Email
        final data = await _loginService.login(email: event.input);
        emit(LoginSuccess(data));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
