// lib/bloc/user_address_insert/user_address_insert_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/address_service/user_address_insert_service.dart';
import 'user_address_insert_event.dart';
import 'user_address_insert_state.dart';

class UserAddressInsertBloc extends Bloc<UserAddressInsertEvent, UserAddressInsertState> {
  final UserAddressInsertService _service;

  UserAddressInsertBloc({required UserAddressInsertService service})
      : _service = service,
        super(UserAddressInsertInitial()) {
    on<InsertUserAddress>(_onInsertUserAddress);
  }

  void _onInsertUserAddress(
      InsertUserAddress event,
      Emitter<UserAddressInsertState> emit,
      ) async {
    emit(UserAddressInsertLoading());
    try {
      final response = await _service.insertUserAddress(event.request);
      if (response.succeeded) {
        emit(UserAddressInsertSuccess(response));
      } else {
        // Handle API succeeding but returning a non-successful outcome message
        final errorMessage = response.messages.isNotEmpty
            ? response.messages.join(', ')
            : response.message;
        emit(UserAddressInsertFailure(errorMessage));
      }
    } catch (e) {
      // Handle network errors or exceptions thrown by the service
      print("Bloc Error: ${e.toString()}");
      emit(UserAddressInsertFailure(e.toString()));
    }
  }
}