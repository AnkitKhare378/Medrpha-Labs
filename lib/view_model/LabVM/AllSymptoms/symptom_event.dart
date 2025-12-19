// lib/view_model/SymptomVM/symptom_event.dart
import 'package:equatable/equatable.dart';

abstract class SymptomEvent extends Equatable {
  const SymptomEvent();
  @override
  List<Object> get props => [];
}

class FetchSymptomsEvent extends SymptomEvent {}