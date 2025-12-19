// lib/cubits/wishlist/wishlist_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/wishlist_service/wishlist_service.dart';

// --- State Definitions ---

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final bool isWished;
  final String message;

  WishlistLoaded({required this.isWished, required this.message});
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
}

// --- Cubit Implementation ---

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistService _wishlistService;
  final int _userId;
  final int _productId;
  final int _categoryId;

  WishlistCubit(
      this._wishlistService,
      bool initialIsWished,
      this._userId,
      this._productId,
      this._categoryId,
  ) : super(WishlistLoaded(isWished: initialIsWished, message: 'Initial state.'));

  Future<void> toggleWishlist() async {
    final currentState = state is WishlistLoaded
        ? (state as WishlistLoaded).isWished
        : false;

    if (state is WishlistLoading) return;

    emit(WishlistLoading());

    try {
      final response = await _wishlistService.toggleWishlist(
        _userId,
        _productId,
        _categoryId,
      );

      final newIsWished = response.isWished;

      emit(WishlistLoaded(
        isWished: newIsWished,
        message: response.message,
      ));
      print('Wishlist toggled: ${response.message}');


    } catch (e) {
      emit(WishlistLoaded(
        isWished: currentState,
        message: 'Toggle failed. ${e.toString()}',
      ));
      emit(WishlistError('Failed to update wishlist: ${e.toString()}'));

    }
  }
}