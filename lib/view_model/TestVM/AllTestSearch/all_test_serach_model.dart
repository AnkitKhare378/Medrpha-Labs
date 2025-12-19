import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/test_service/all_test_search.dart';
import '../../../models/TestM/test_search_model.dart';

class TestSearchBloc extends Bloc<TestSearchEvent, TestSearchState> {
  final AllTestSearchService _service;

  TestSearchBloc(this._service) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<ClearSearch>(_onClearSearch);
  }

  void _onSearchQueryChanged(
      SearchQueryChanged event,
      Emitter<TestSearchState> emit,
      ) async {
    final query = event.query.trim();

    // ✅ FIX: Immediately return to Initial state if the query is empty.
    if (query.isEmpty) {
      return emit(SearchInitial());
    }

    emit(SearchLoading());

    try {
      final results = await _service.searchTests(query);
      emit(SearchSuccess(results));
    } catch (e) {
      // If the error message is "Failed to fetch search results.",
      // it should be defined here:
      emit(SearchError('Failed to fetch search results.'));
    }
  }

  void _onClearSearch(
      ClearSearch event,
      Emitter<TestSearchState> emit,
      ) {
    // ClearSearch simply resets the state to initial
    emit(SearchInitial());
  }
}

abstract class TestSearchEvent {}

/// Event triggered when the user types a search query.
class SearchQueryChanged extends TestSearchEvent {
  final String query;

  SearchQueryChanged(this.query);
}

/// Event to clear the search results and state.
class ClearSearch extends TestSearchEvent {}

// file: lib/blocs/test_search/test_search_state.dart


abstract class TestSearchState {
  final List<TestSearchModel> results;

  TestSearchState({required this.results});
}

/// Initial state, or state after clearing the search.
class SearchInitial extends TestSearchState {
  SearchInitial() : super(results: []);
}

/// State when a search is currently in progress.
class SearchLoading extends TestSearchState {
  SearchLoading() : super(results: []);
}

/// State when the search has successfully returned results (or an empty list).
class SearchSuccess extends TestSearchState {
  SearchSuccess(List<TestSearchModel> results) : super(results: results);
}

/// State when an error occurs during the search.
class SearchError extends TestSearchState {
  final String message;

  SearchError(this.message) : super(results: []);
}

