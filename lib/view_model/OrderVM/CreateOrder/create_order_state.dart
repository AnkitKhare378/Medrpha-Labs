import 'package:equatable/equatable.dart';
import '../../../../../models/OrderM/order_response_model.dart';

abstract class CreateOrderState extends Equatable {
  const CreateOrderState();
  @override
  List<Object> get props => [];
}

class CreateOrderInitial extends CreateOrderState {}

class CreateOrderLoading extends CreateOrderState {}

class CreateOrderSuccess extends CreateOrderState {
  final OrderResponseModel response;
  const CreateOrderSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class CreateOrderFailure extends CreateOrderState {
  final String message;
  const CreateOrderFailure(this.message);

  @override
  List<Object> get props => [message];
}