import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends HomeEvent {
  final String userId;
  const LoadUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
