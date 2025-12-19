import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/repositories/order_service/order_service.dart';
import 'create_order_event.dart';
import 'create_order_state.dart';

class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  final OrderService _orderService;

  CreateOrderBloc(this._orderService) : super(CreateOrderInitial()) {
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  Future<void> _onPlaceOrder(
      PlaceOrderEvent event,
      Emitter<CreateOrderState> emit,
      ) async {
    emit(CreateOrderLoading());
    try {
      final response = await _orderService.createOrder(
        userId: event.userId,
        cartId: event.cartId,
        paymentMethod: event.paymentMethodId,
        subTotal: event.subTotal,
        discountAmount: event.discountAmount,
        finalAmount: event.finalAmount, userAddressId: event.userAddressId,
      );

      if (response.succeeded) {
        emit(CreateOrderSuccess(response));
      } else {
        // Handle API success=false cases (e.g., item out of stock)
        emit(CreateOrderFailure(response.message ?? "Order creation failed."));
      }
    } catch (e) {
      emit(CreateOrderFailure("Could not finalize order. ${e.toString()}"));
    }
  }
}