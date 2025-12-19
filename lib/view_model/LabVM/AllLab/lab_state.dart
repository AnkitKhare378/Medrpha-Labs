// lib/bloc/lab/lab_state.dart
import 'package:equatable/equatable.dart';

import '../../../models/LabM/lab_model.dart';

abstract class LabState extends Equatable {
  const LabState();

  @override
  List<Object> get props => [];
}

class LabInitial extends LabState {}

class LabLoading extends LabState {}

class LabLoaded extends LabState {
  final List<LabModel> labs;
  const LabLoaded(this.labs);

  @override
  List<Object> get props => [labs];
}

class LabError extends LabState {
  final String message;
  const LabError(this.message);

  @override
  List<Object> get props => [message];
}