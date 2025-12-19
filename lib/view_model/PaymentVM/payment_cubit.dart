// viewmodels/payment_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/payment_method_service/payment_service.dart';
import 'payment_state.dart'; // Assuming the state file is alongside the cubit

/// Cubit to manage the state of fetching payment methods.
class PaymentCubit extends Cubit<PaymentState> {
  final PaymentService _paymentService;

  PaymentCubit(this._paymentService) : super(PaymentInitial());

  /// Fetches payment methods and emits the corresponding state.
  Future<void> fetchPaymentMethods() async {
    // 1. Emit Loading state
    emit(PaymentLoading());
    try {
      // 2. Call the service
      final methodList = await _paymentService.fetchPaymentMethods();

      // 3. Emit Loaded state
      emit(PaymentLoaded(methods: methodList.methods));
    } catch (e) {
      // 4. Emit Error state
      emit(PaymentError(message: e.toString()));
    }
  }
}