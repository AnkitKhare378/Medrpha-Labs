// lib/bloc/lab/lab_event.dart
import 'package:equatable/equatable.dart';

abstract class LabEvent extends Equatable {
  const LabEvent();

  @override
  List<Object> get props => [];
}

class FetchLabsEvent extends LabEvent {}