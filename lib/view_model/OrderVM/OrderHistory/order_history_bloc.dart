// file: lib/view_model/OrderVM/OrderHistory/order_history_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/order_service/order__history_service.dart';
import '../../../models/OrderM/order_history.dart';

// --- Events ---
abstract class OrderHistoryEvent {}

class FetchOrderHistoryEvent extends OrderHistoryEvent {
  final int userId;
  final int? orderId;
  final String? status;
  final String? timeRange;

  FetchOrderHistoryEvent({
    required this.userId,
    this.orderId,
    this.status,
    this.timeRange,
  });
}

// --- States ---
abstract class OrderHistoryState {}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<OrderHistoryModel> orders;
  OrderHistoryLoaded(this.orders); // Positional argument
}

class OrderHistoryError extends OrderHistoryState {
  final String message;
  OrderHistoryError(this.message); // Positional argument
}

// --- BLoC ---
class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderHistoryService _service;

  OrderHistoryBloc(this._service) : super(OrderHistoryInitial()) {
    on<FetchOrderHistoryEvent>(_onFetchOrderHistory);
  }

  Future<void> _onFetchOrderHistory(
      FetchOrderHistoryEvent event, Emitter<OrderHistoryState> emit) async {
    emit(OrderHistoryLoading());
    try {
      // 1. Fetch data using the private _service field
      final response = await _service.fetchOrderHistory(
        userId: event.userId,
        orderId: event.orderId,
      );

      List<OrderHistoryModel> allOrders = response;

      // 2. Filter by Status (Local Filtering)
      if (event.status != null) {
        allOrders = allOrders.where((order) {
          return _checkStatusMatch(event.status!, order.status);
        }).toList();
      }

      // 3. Filter by Time Range (Local Filtering)
      if (event.timeRange != null) {
        final now = DateTime.now();
        allOrders = allOrders.where((order) {
          if (event.timeRange == "Last 30 days") {
            return order.orderDate.isAfter(now.subtract(const Duration(days: 30)));
          } else if (event.timeRange == "2024") {
            return order.orderDate.year == 2024;
          } else if (event.timeRange == "2023") {
            return order.orderDate.year == 2023;
          }
          return true;
        }).toList();
      }

      // FIXED: Remove the 'orders:' and 'message:' labels for positional constructors
      emit(OrderHistoryLoaded(allOrders));
    } catch (e) {
      emit(OrderHistoryError(e.toString()));
    }
  }

  // FIXED: Moved this helper outside the constructor so it's a proper class method
  bool _checkStatusMatch(String uiLabel, String jsonStatus) {
    final label = uiLabel.toLowerCase();
    final status = jsonStatus.toLowerCase();

    if (label == "on the way") return status == "shipped" || status == "scheduled" || status == "ordered";
    if (label == "delivered") return status == "delivered" || status == "completed";
    if (label == "cancelled") return status == "cancelled";
    if (label == "returned") return status == "returned";

    return label == status;
  }
}