// File: lib/blocs/cart/get_cart_event_state.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// Note: Remove the unused imports from the original provided file
// import '../../data/repositories/cart_service/get_cart_service.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/cart_service/get_cart_service.dart';
import '../../models/CartM/get_cart_model.dart'; // Ensure path is correct

// ------------------- Events -------------------

abstract class GetCartEvent extends Equatable {
  const GetCartEvent();

  @override
  List<Object> get props => [];
}

/// Event to trigger fetching the cart data for a specific user ID.
class FetchCart extends GetCartEvent {
  final int userId;

  const FetchCart(this.userId);

  @override
  List<Object> get props => [userId];
}

// ------------------- States -------------------

abstract class GetCartState extends Equatable {
  const GetCartState();

  @override
  List<Object> get props => [];
}

/// Initial state of the cart BLoC.
class GetCartInitial extends GetCartState {}

/// State when the cart data is being loaded.
class GetCartLoading extends GetCartState {}

/// State when the cart data has been successfully loaded.
class GetCartLoaded extends GetCartState {
  final CartData cart;

  const GetCartLoaded(this.cart);

  @override
  List<Object> get props => [cart];
}

/// State when there is an error fetching the cart data.
class GetCartError extends GetCartState {
  final String message;

  const GetCartError(this.message);

  @override
  List<Object> get props => [message];
}

/// State when the cart data is loaded but the cart is empty (no data returned).
class GetCartEmpty extends GetCartState {}



class GetCartBloc extends Bloc<GetCartEvent, GetCartState> {
  final GetCartService _cartService;

  GetCartBloc(this._cartService) : super(GetCartInitial()) {
    on<FetchCart>(_onFetchCart);
  }

  Future<void> _onFetchCart(
      FetchCart event,
      Emitter<GetCartState> emit,
      ) async {
    emit(GetCartLoading());
    try {
      final response = await _cartService.getCart(event.userId);

      if (response.succeeded && response.data.isNotEmpty) {
        // Assuming the API returns a single cart object in the 'data' array
        final cartData = response.data.first;
        emit(GetCartLoaded(cartData));
      } else if (response.succeeded && response.data.isEmpty) {
        // Successful response but cart is empty
        emit(GetCartEmpty());
      } else {
        // Failed but 'succeeded' is false (should be caught by service, but good to check)
        emit(GetCartError(
            response.message ?? 'Failed to load cart. Unknown reason.'));
      }
    } catch (e) {
      // Catch exceptions from the service (e.g., network errors, API failure message)
      emit(GetCartError(e.toString()));
    }
  }
}