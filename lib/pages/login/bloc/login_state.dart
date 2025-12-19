import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginOtpSent extends LoginState {
  final String phoneNumber;
  LoginOtpSent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}
class LoginError extends LoginState {
  final String message;
  LoginError(this.message);

  @override
  List<Object?> get props => [message];
}
