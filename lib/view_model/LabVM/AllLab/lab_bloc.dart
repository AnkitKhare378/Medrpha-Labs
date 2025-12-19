// lib/bloc/lab/lab_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/lab_service/lab_service.dart';
import 'lab_event.dart';
import 'lab_state.dart';

class LabBloc extends Bloc<LabEvent, LabState> {
  final LabService labService;

  LabBloc(this.labService) : super(LabInitial()) {
    on<FetchLabsEvent>(_onFetchLabs);
  }

  void _onFetchLabs(
      FetchLabsEvent event, Emitter<LabState> emit) async {
    emit(LabLoading());
    try {
      final labs = await labService.fetchLabs();
      // Introduce a small delay to visually show the loading state (optional)
      // await Future.delayed(const Duration(milliseconds: 500));
      emit(LabLoaded(labs));
    } catch (e) {
      // Catch the exception from the service and provide an error message
      emit(LabError('Failed to fetch labs. Error: $e'));
    }
  }
}