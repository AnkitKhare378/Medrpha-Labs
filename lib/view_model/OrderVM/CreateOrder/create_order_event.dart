import 'package:equatable/equatable.dart';

abstract class CreateOrderEvent extends Equatable {
  const CreateOrderEvent();
  @override
  List<Object> get props => [];
}

class PlaceOrderEvent extends CreateOrderEvent {
  final int userId;
  final int userAddressId;
  final int cartId; // Assuming you can fetch this from a CartProvider or similar
  final int paymentMethodId;
  final double subTotal;
  final double discountAmount;
  final double finalAmount;
  final String orderTime;
  final String orderDate;

  const PlaceOrderEvent({
    required this.userId,
    required this.cartId,
    required this.userAddressId,
    required this.paymentMethodId,
    required this.subTotal,
    required this.discountAmount,
    required this.finalAmount,
    required this.orderTime,
    required this.orderDate,
  });

  @override
  List<Object> get props => [userId, cartId, paymentMethodId, subTotal, discountAmount, finalAmount, orderTime, orderDate];
}