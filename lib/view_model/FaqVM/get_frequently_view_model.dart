// File: lib/view_model/FaqVM/get_frequently_view_model.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/faq_service/get_frequently_service.dart';
import '../../models/FaqM/get_frequently_model.dart';

// --- Events ---
abstract class FrequentlyEvent {
  const FrequentlyEvent();
}

class FetchFaqs extends FrequentlyEvent {
  const FetchFaqs();
}

// --- States ---
abstract class FrequentlyState {
  const FrequentlyState();
}

class FrequentlyInitial extends FrequentlyState {}

class FrequentlyLoading extends FrequentlyState {}

class FrequentlyLoaded extends FrequentlyState {
  final List<FrequentlyModel> faqs;
  const FrequentlyLoaded(this.faqs);
}

class FrequentlyError extends FrequentlyState {
  final String message;
  const FrequentlyError(this.message);
}

// --- BLoC ---
class FrequentlyBloc extends Bloc<FrequentlyEvent, FrequentlyState> {
  // 1. Make the service a final field
  final FrequentlyService _service;

  // 2. Update the constructor to require the service
  FrequentlyBloc(this._service) : super(FrequentlyInitial()) {
    on<FetchFaqs>(_onFetchFaqs);
  }

  Future<void> _onFetchFaqs(
      FetchFaqs event,
      Emitter<FrequentlyState> emit,
      ) async {
    emit(FrequentlyLoading());
    try {
      // 3. Use the injected service instance
      final faqs = await _service.fetchFaqs();
      emit(FrequentlyLoaded(faqs));
    } catch (e) {
      emit(FrequentlyError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}