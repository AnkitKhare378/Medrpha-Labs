import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/rating_service/get_rating_service.dart';
import '../../models/RatingM/get_rating_model.dart';

abstract class GetRatingState extends Equatable {
  const GetRatingState();

  @override
  List<Object> get props => [];
}

class GetRatingInitial extends GetRatingState {}

class GetRatingLoading extends GetRatingState {}

class GetRatingLoaded extends GetRatingState {
  final List<RatingDetailModel> ratings;
  const GetRatingLoaded(this.ratings);

  @override
  List<Object> get props => [ratings];
}

class GetRatingError extends GetRatingState {
  final String error;
  const GetRatingError(this.error);

  @override
  List<Object> get props => [error];
}

// --- BLoC Cubit ---

class GetRatingCubit extends Cubit<GetRatingState> {
  final GetRatingService _ratingService;

  GetRatingCubit(this._ratingService) : super(GetRatingInitial());

  Future<void> fetchRatings({
    required int categoryId,
    required int productId,
  }) async {
    emit(GetRatingLoading());

    try {
      final ratings = await _ratingService.getRatingDetails(
        categoryId: categoryId,
        productId: productId,
      );

      emit(GetRatingLoaded(ratings));
    } catch (e) {
      // The API call failure
      emit(GetRatingError("Failed to load ratings: ${e.toString()}"));
    }
  }
}