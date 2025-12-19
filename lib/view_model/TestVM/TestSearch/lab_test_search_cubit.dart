import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repositories/test_service/test_search_service.dart';
import '../../../models/TestM/lab_test.dart';

abstract class LabTestState extends Equatable {
  const LabTestState();
  @override
  List<Object> get props => [];
}

class LabTestInitial extends LabTestState {}
class LabTestLoading extends LabTestState {}
class LabTestLoaded extends LabTestState {
  final List<LabTest> tests;
  const LabTestLoaded(this.tests);
  @override
  List<Object> get props => [tests];
}
class LabTestError extends LabTestState {
  final String message;
  const LabTestError(this.message);
  @override
  List<Object> get props => [message];
}

// --- CUBIT IMPLEMENTATION ---

class LabTestSearchCubit extends Cubit<LabTestState> {
  final TestSearchService _testSearchService;

  LabTestSearchCubit(this._testSearchService) : super(LabTestInitial());

  Future<void> searchLabTests({
    required String name,
    required int labId,
    required int symptomId,
  }) async {
    // Always show shimmer before fetching
    emit(LabTestLoading());
    try {
      final tests = await _testSearchService.searchTests(
        name: name,
        labId: labId,
        symptomId: symptomId,
      );

      emit(LabTestLoaded(tests));
    } catch (e) {
      emit(LabTestError("Failed to search lab tests: ${e.toString()}"));
    }
  }
}