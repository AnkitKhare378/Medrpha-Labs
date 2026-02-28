// lib/view_model/OrderVM/OrderHistory/order_document_view_model.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/order_service/order_document_service.dart';
import '../../../models/OrderM/order_document_model.dart';

// Events
abstract class OrderDocumentEvent {}
class FetchOrderDocument extends OrderDocumentEvent {
  final int orderId;
  FetchOrderDocument(this.orderId);
}

// States
abstract class OrderDocumentState {}
class OrderDocumentInitial extends OrderDocumentState {}
class OrderDocumentLoading extends OrderDocumentState {}

// 🎯 NEW STATE: For data: null cases
class OrderDocumentEmpty extends OrderDocumentState {}

class OrderDocumentLoaded extends OrderDocumentState {
  final OrderDocumentModel document;
  OrderDocumentLoaded(this.document);
}

class OrderDocumentError extends OrderDocumentState {
  final String message;
  OrderDocumentError(this.message);
}

// Bloc
class OrderDocumentBloc extends Bloc<OrderDocumentEvent, OrderDocumentState> {
  final OrderDocumentService service;

  OrderDocumentBloc(this.service) : super(OrderDocumentInitial()) {
    on<FetchOrderDocument>((event, emit) async {
      emit(OrderDocumentLoading());
      try {
        final result = await service.getOrderDocument(event.orderId);

        // 🎯 Logic for handling data: null
        if (result.succeeded) {
          if (result.data != null) {
            emit(OrderDocumentLoaded(result.data!));
          } else {
            // Success but no data
            emit(OrderDocumentEmpty());
          }
        } else {
          emit(OrderDocumentError("Failed to fetch document"));
        }
      } catch (e) {
        emit(OrderDocumentError(e.toString()));
      }
    });
  }
}