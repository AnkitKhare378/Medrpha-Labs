import 'package:equatable/equatable.dart';

import '../../../models/AccountM/verify_otp_model.dart';

abstract class VerifyOtpState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  final VerifyOtpModel response;
  VerifyOtpSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class VerifyOtpError extends VerifyOtpState {
  final String message;
  VerifyOtpError(this.message);

  @override
  List<Object?> get props => [message];
}
