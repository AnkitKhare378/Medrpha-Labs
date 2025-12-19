// lib/view_model/AddressVM/GetUserAddressById/get_user_address_by_id_view_model.dart (UPDATED)

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/address_service/get_user_address_by_id_service.dart';
import '../../../models/AddressM/get_user_address_by_id_model.dart';

// --- State ---
// ... (State classes remain the same) ...
abstract class GetUserAddressByIdState extends Equatable {
  const GetUserAddressByIdState();

  @override
  List<Object> get props => [];
}

class GetUserAddressByIdInitial extends GetUserAddressByIdState {}

class GetUserAddressByIdLoading extends GetUserAddressByIdState {}

class GetUserAddressByIdLoaded extends GetUserAddressByIdState {
  final GetUserAddressByIdModel address;
  const GetUserAddressByIdLoaded(this.address);

  @override
  List<Object> get props => [address];
}

class GetUserAddressByIdError extends GetUserAddressByIdState {
  final String message;
  const GetUserAddressByIdError(this.message);

  @override
  List<Object> get props => [message];
}

// --- Event ---
// ... (Event classes remain the same) ...
class GetUserAddressByIdEvent extends Equatable {
  const GetUserAddressByIdEvent();

  @override
  List<Object> get props => [];
}

class FetchUserAddressById extends GetUserAddressByIdEvent {
  final String addressId;
  const FetchUserAddressById(this.addressId);

  @override
  List<Object> get props => [addressId];
}

// --- BLoC ---
class GetUserAddressByIdBloc extends Bloc<GetUserAddressByIdEvent, GetUserAddressByIdState> {
  // 🛠️ CHANGED: Use a final variable to hold the injected service
  final GetUserAddressByIdService _service;

  // 🛠️ CHANGED: Require the service in the constructor
  GetUserAddressByIdBloc({required GetUserAddressByIdService service})
      : _service = service,
        super(GetUserAddressByIdInitial()) {
    on<FetchUserAddressById>(_onFetchUserAddressById);
  }

  void _onFetchUserAddressById(
      FetchUserAddressById event,
      Emitter<GetUserAddressByIdState> emit,
      ) async {
    emit(GetUserAddressByIdLoading());
    try {
      // 🛠️ Use the injected service
      final address = await _service.fetchUserAddressById(event.addressId);
      emit(GetUserAddressByIdLoaded(address));
    } catch (e) {
      emit(GetUserAddressByIdError(e.toString()));
    }
  }
}