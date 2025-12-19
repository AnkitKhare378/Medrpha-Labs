import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {}
class OtpVerifying extends OtpState {}
class OtpVerified extends OtpState {}
class OtpError extends OtpState {
  final String message;
  OtpError(this.message);

  @override
  List<Object?> get props => [message];
}
