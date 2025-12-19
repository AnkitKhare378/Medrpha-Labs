import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repositories/address_service/user_address_update_service.dart';
import '../../../models/AddressM/user_address_insert_model.dart';

abstract class UserAddressUpdateState extends Equatable {
  const UserAddressUpdateState();

  @override
  List<Object> get props => [];
}

class UserAddressUpdateInitial extends UserAddressUpdateState {}

class UserAddressUpdateLoading extends UserAddressUpdateState {}

class UserAddressUpdateSuccess extends UserAddressUpdateState {
  final UserAddressUpdateResponse response;
  const UserAddressUpdateSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class UserAddressUpdateFailure extends UserAddressUpdateState {
  final String error;
  const UserAddressUpdateFailure(this.error);

  @override
  List<Object> get props => [error];
}

// --- Event ---
abstract class UserAddressUpdateEvent extends Equatable {
  const UserAddressUpdateEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserAddress extends UserAddressUpdateEvent {
  final UserAddressUpdateRequest request;
  const UpdateUserAddress(this.request);

  @override
  List<Object> get props => [request];
}

class UserAddressUpdateBloc extends Bloc<UserAddressUpdateEvent, UserAddressUpdateState> {
  final UserAddressUpdateService _service;

  UserAddressUpdateBloc({required UserAddressUpdateService service})
      : _service = service,
        super(UserAddressUpdateInitial()) {
    on<UpdateUserAddress>(_onUpdateUserAddress);
  }

  void _onUpdateUserAddress(
      UpdateUserAddress event,
      Emitter<UserAddressUpdateState> emit,
      ) async {
    emit(UserAddressUpdateLoading());
    try {
      final response = await _service.updateAddress(event.request);
      if (response.succeeded) {
        emit(UserAddressUpdateSuccess(response));
      } else {
        emit(UserAddressUpdateFailure(response.message));
      }
    } catch (e) {
      emit(UserAddressUpdateFailure(e.toString()));
    }
  }
}