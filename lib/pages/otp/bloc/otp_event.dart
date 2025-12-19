import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OtpSubmitted extends OtpEvent {
  final String otp;
  OtpSubmitted(this.otp);

  @override
  List<Object?> get props => [otp];
}
