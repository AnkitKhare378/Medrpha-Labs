// lib/view_model/SymptomVM/symptom_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/lab_service/symptom_service.dart';
import 'symptom_event.dart';
import 'symptom_state.dart';

class SymptomBloc extends Bloc<SymptomEvent, SymptomState> {
  final SymptomService symptomService;

  SymptomBloc(this.symptomService) : super(SymptomInitial()) {
    on<FetchSymptomsEvent>(_onFetchSymptoms);
  }

  void _onFetchSymptoms(
      FetchSymptomsEvent event, Emitter<SymptomState> emit) async {
    emit(SymptomLoading());
    try {
      final symptoms = await symptomService.fetchSymptoms();
      emit(SymptomLoaded(symptoms));
    } catch (e) {
      emit(SymptomError('Failed to fetch symptoms: ${e.toString()}'));
    }
  }
}