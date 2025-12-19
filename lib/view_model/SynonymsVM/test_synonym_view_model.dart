import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/synonym_service/test_synonyms_service.dart';
import '../../models/SynonymsM/test_synonyms_model.dart';

// --- Events ---
abstract class TestSynonymEvent extends Equatable {
  const TestSynonymEvent();

  @override
  List<Object> get props => [];
}

class FetchTestSynonyms extends TestSynonymEvent {
  final int testId;

  const FetchTestSynonyms(this.testId);

  @override
  List<Object> get props => [testId];
}

// --- States ---
abstract class TestSynonymState extends Equatable {
  const TestSynonymState();

  @override
  List<Object> get props => [];
}

class TestSynonymInitial extends TestSynonymState {}

class TestSynonymLoading extends TestSynonymState {}

class TestSynonymLoaded extends TestSynonymState {
  final List<TestSynonymModel> synonyms;

  const TestSynonymLoaded(this.synonyms);

  @override
  List<Object> get props => [synonyms];
}

class TestSynonymError extends TestSynonymState {
  final String message;

  const TestSynonymError(this.message);

  @override
  List<Object> get props => [message];
}

// --- BLoC ---
class TestSynonymBloc extends Bloc<TestSynonymEvent, TestSynonymState> {
  final TestSynonymsService _service;

  TestSynonymBloc(this._service) : super(TestSynonymInitial()) {
    on<FetchTestSynonyms>(_onFetchTestSynonyms);
  }

  void _onFetchTestSynonyms(
      FetchTestSynonyms event,
      Emitter<TestSynonymState> emit,
      ) async {
    emit(TestSynonymLoading());
    try {
      final synonyms = await _service.fetchTestSynonyms(event.testId);
      emit(TestSynonymLoaded(synonyms));
    } catch (e) {
      emit(TestSynonymError(e.toString()));
    }
  }
}