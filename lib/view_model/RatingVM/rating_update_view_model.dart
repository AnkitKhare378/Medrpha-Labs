// Path: lib/view_model/RatingVM/rating_update_view_model.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medrpha_labs/data/repositories/rating_service/rating_update_service.dart'; // Update path

// --- State ---

abstract class RatingUpdateState {}

class RatingUpdateInitial extends RatingUpdateState {}

class RatingUpdateLoading extends RatingUpdateState {}

class RatingUpdateSuccess extends RatingUpdateState {
  final String message;
  RatingUpdateSuccess(this.message);
}

class RatingUpdateError extends RatingUpdateState {
  final String error;
  RatingUpdateError(this.error);
}

// --- Cubit ---

class RatingUpdateCubit extends Cubit<RatingUpdateState> {
  final RatingUpdateService _service;

  RatingUpdateCubit(this._service) : super(RatingUpdateInitial());

  Future<void> updateRating({
    required int ratingId,
    required String remark,
    required int ratingPoint,
    required int categoryId,
    required int productId,
  }) async {
    emit(RatingUpdateLoading());
    try {
      final response = await _service.updateRating(
        ratingId: ratingId,
        remark: remark,
        ratingPoint: ratingPoint,
        categoryId: categoryId,
        productId: productId,
      );

      emit(RatingUpdateSuccess(response.message));
    } catch (e) {
      emit(RatingUpdateError(e.toString()));
    }
  }
}