import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repositories/test_service/test_detail_service.dart';
import '../../../models/TestM/test_detail_model.dart';

// --- Events ---
abstract class TestDetailEvent extends Equatable {
  const TestDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTestDetail extends TestDetailEvent {
  final int testId;

  const FetchTestDetail(this.testId);

  @override
  List<Object> get props => [testId];
}

// --- States ---
abstract class TestDetailState extends Equatable {
  const TestDetailState();

  @override
  List<Object> get props => [];
}

class TestDetailInitial extends TestDetailState {}

class TestDetailLoading extends TestDetailState {}

class TestDetailLoaded extends TestDetailState {
  final TestDetailModel testDetail;

  const TestDetailLoaded(this.testDetail);

  @override
  List<Object> get props => [testDetail];
}

class TestDetailError extends TestDetailState {
  final String message;

  const TestDetailError(this.message);

  @override
  List<Object> get props => [message];
}

// --- BLoC ---
class TestDetailBloc extends Bloc<TestDetailEvent, TestDetailState> {
  final TestDetailService _service;

  TestDetailBloc(this._service) : super(TestDetailInitial()) {
    on<FetchTestDetail>(_onFetchTestDetail);
  }

  void _onFetchTestDetail(
      FetchTestDetail event,
      Emitter<TestDetailState> emit,
      ) async {
    emit(TestDetailLoading());
    try {
      final testDetail = await _service.getTestDetail(event.testId);
      emit(TestDetailLoaded(testDetail));
    } catch (e) {
      emit(TestDetailError(e.toString()));
    }
  }
}