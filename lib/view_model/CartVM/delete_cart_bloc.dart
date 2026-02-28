// file: lib/view_model/CartVM/DeleteCart/delete_cart_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/CartM/delete_cart_model.dart';
import '../../data/repositories/delete_service/delete_service_dart.dart';

// Events
abstract class DeleteCartEvent {}
class ClearCartEvent extends DeleteCartEvent {
  final int cartId;
  ClearCartEvent(this.cartId);
}

// States
abstract class DeleteCartState {}
class DeleteCartInitial extends DeleteCartState {}
class DeleteCartLoading extends DeleteCartState {}
class DeleteCartSuccess extends DeleteCartState {
  final String message;
  DeleteCartSuccess(this.message);
}
class DeleteCartError extends DeleteCartState {
  final String error;
  DeleteCartError(this.error);
}

// BLoC
class DeleteCartBloc extends Bloc<DeleteCartEvent, DeleteCartState> {
  final DeleteCartService _service;

  DeleteCartBloc(this._service) : super(DeleteCartInitial()) {
    on<ClearCartEvent>((event, emit) async {
      emit(DeleteCartLoading());
      try {
        final response = await _service.deleteCart(event.cartId);
        if (response.succeeded) {
          emit(DeleteCartSuccess(response.message ?? "Cart cleared"));
        } else {
          emit(DeleteCartError(response.message ?? "Failed to delete cart"));
        }
      } catch (e) {
        emit(DeleteCartError(e.toString()));
      }
    });
  }
}