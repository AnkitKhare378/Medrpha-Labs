import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/wishlist_service/get_wishlist_service.dart';
import 'get_wishlist_event.dart';
import 'get_wishlist_state.dart';


class GetWishlistBloc extends Bloc<GetWishlistEvent, GetWishlistState> {
  final GetWishlistService wishlistService;

  GetWishlistBloc({required this.wishlistService}) : super(GetWishlistInitial()) {
    on<FetchWishlist>(_onFetchWishlist);
    // You would implement RemoveFromWishlist here, too
    // on<RemoveFromWishlist>(_onRemoveFromWishlist);
  }

  void _onFetchWishlist(
      FetchWishlist event,
      Emitter<GetWishlistState> emit,
      ) async {
    emit(GetWishlistLoading());
    try {
      // In a real app, you'd fetch the product details using productId here.
      final items = await wishlistService.getWishlist(event.userId);
      emit(GetWishlistLoaded(items));
    } catch (e) {
      emit(GetWishlistError(e.toString()));
      // Logging the error internally for debugging
      print('WishlistBloc Error: $e');
    }
  }
}