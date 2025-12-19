import 'package:equatable/equatable.dart';

abstract class VerifyOtpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyOtpSubmitted extends VerifyOtpEvent {
  final String input;
  final String otp;
  final String deviceToken;

  VerifyOtpSubmitted(this.input, this.otp, this.deviceToken);

  @override
  List<Object?> get props => [input, otp];
}
