import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/rating_service/insert_rating_service.dart';

abstract class InsertRatingState extends Equatable {
  const InsertRatingState();

  @override
  List<Object> get props => [];
}

class InsertRatingInitial extends InsertRatingState {}

class InsertRatingLoading extends InsertRatingState {}

class InsertRatingSuccess extends InsertRatingState {
  final String message;
  const InsertRatingSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class InsertRatingError extends InsertRatingState {
  final String error;
  const InsertRatingError(this.error);

  @override
  List<Object> get props => [error];
}

// --- BLoC Cubit ---

class InsertRatingCubit extends Cubit<InsertRatingState> {
  final InsertRatingService _ratingService;

  InsertRatingCubit(this._ratingService) : super(InsertRatingInitial());

  Future<void> submitRating({
    required String remark,
    required int ratingpoint,
    required int categoryId,
    required int productId,
  }) async {
    if (ratingpoint == 0) {
      emit(const InsertRatingError("Please select a star rating."));
      return;
    }

    emit(InsertRatingLoading());

    try {
      final response = await _ratingService.insertRating(
        remark: remark,
        ratingpoint: ratingpoint,
        categoryId: categoryId,
        productId: productId,
      );

      if (response.succeeded) {
        emit(InsertRatingSuccess(response.message));
      } else {
        emit(InsertRatingError(response.message));
      }
    } catch (e) {
      // The API call failure or SharedPreferences error
      emit(InsertRatingError("Submission failed: ${e.toString()}"));
    }
  }
}