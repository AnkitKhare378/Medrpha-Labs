// lib/view_model/SymptomVM/symptom_state.dart
import 'package:equatable/equatable.dart';

import '../../../models/LabM/symptom_model.dart';

abstract class SymptomState extends Equatable {
  const SymptomState();
  @override
  List<Object> get props => [];
}

class SymptomInitial extends SymptomState {}

class SymptomLoading extends SymptomState {}

class SymptomLoaded extends SymptomState {
  final List<SymptomModel> symptoms;
  const SymptomLoaded(this.symptoms);
  @override
  List<Object> get props => [symptoms];
}

class SymptomError extends SymptomState {
  final String message;
  const SymptomError(this.message);
  @override
  List<Object> get props => [message];
}