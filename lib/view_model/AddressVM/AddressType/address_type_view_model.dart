// lib/viewModel/AddressVM/address_type_view_model.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/address_service/address_type_service.dart';
import '../../../models/AddressM/address_type_model.dart';
part 'address_type_event.dart';
part 'address_type_state.dart';

class AddressTypeBloc extends Bloc<AddressTypeEvent, AddressTypeState> {
  // 1. Change to a final property
  final AddressTypeService _service;

  // 2. Update the constructor to require the service
  AddressTypeBloc({required AddressTypeService service})
      : _service = service, // Initialize the final property
        super(AddressTypeInitial()) {
    on<FetchAddressTypes>(_onFetchAddressTypes);
  }

  Future<void> _onFetchAddressTypes(
      FetchAddressTypes event,
      Emitter<AddressTypeState> emit,
      ) async {
    emit(AddressTypeLoading());
    try {
      // 3. Use the injected service
      final types = await _service.fetchAddressTypes();
      emit(AddressTypeLoaded(types));
    } catch (e) {
      emit(AddressTypeError(e.toString()));
    }
  }
}