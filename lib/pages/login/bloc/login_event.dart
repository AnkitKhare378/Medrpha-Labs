import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PhoneSubmitted extends LoginEvent {
  final String phoneNumber;
  PhoneSubmitted(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}
