// lib/view_model/RatingVM/rating_delete_view_model.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/rating_service/rating_delete_service.dart';

// --- States ---
abstract class RatingDeleteState {}

class RatingDeleteInitial extends RatingDeleteState {}
class RatingDeleteLoading extends RatingDeleteState {}
class RatingDeleteSuccess extends RatingDeleteState {
  final String message;
  RatingDeleteSuccess(this.message);
}
class RatingDeleteError extends RatingDeleteState {
  final String error;
  RatingDeleteError(this.error);
}

// --- Cubit ---
class RatingDeleteCubit extends Cubit<RatingDeleteState> {
  final RatingDeleteService _service;

  RatingDeleteCubit(this._service) : super(RatingDeleteInitial());

  Future<void> deleteRating(int ratingId) async {
    emit(RatingDeleteLoading());
    try {
      final response = await _service.deleteRating(ratingId: ratingId);

      final successMessage = response.messages.isNotEmpty
          ? response.messages.first
          : 'Rating deleted successfully.';

      emit(RatingDeleteSuccess(successMessage));
    } catch (e) {
      emit(RatingDeleteError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}