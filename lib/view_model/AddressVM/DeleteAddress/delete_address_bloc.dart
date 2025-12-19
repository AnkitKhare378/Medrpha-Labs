// lib/view_model/AddressVM/DeleteUserAddress/delete_address_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/address_service/address_delete_service.dart';
import 'delete_address_event.dart';
import 'delete_address_state.dart';

class DeleteAddressBloc extends Bloc<DeleteAddressEvent, DeleteAddressState> {
  final AddressDeleteService _addressService;

  DeleteAddressBloc({required AddressDeleteService addressDeleteService})
      : _addressService = addressDeleteService,
        super(DeleteAddressInitial()) {
    on<DeleteUserAddress>(_onDeleteUserAddress);
  }

  void _onDeleteUserAddress(
      DeleteUserAddress event,
      Emitter<DeleteAddressState> emit,
      ) async {
    emit(DeleteAddressLoading());
    try {
      final model = await _addressService.deleteAddress(addressId: event.addressId);
      emit(DeleteAddressSuccess(model.message));
    } catch (e) {
      emit(DeleteAddressError(e.toString()));
    }
  }
}