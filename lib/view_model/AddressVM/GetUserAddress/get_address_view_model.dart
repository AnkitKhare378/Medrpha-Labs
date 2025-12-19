// lib/view_model/AddressVM/UserAddress/get_address_view_model.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/address_service/get_user_address_service.dart';
import '../../../models/AddressM/get_address_model.dart';

// --- Events ---
abstract class GetUserAddressEvent extends Equatable {
  const GetUserAddressEvent();
  @override
  List<Object> get props => [];
}

class FetchUserAddresses extends GetUserAddressEvent {
  final String userId;
  const FetchUserAddresses(this.userId);
  @override
  List<Object> get props => [userId];
}

// --- States ---
abstract class GetUserAddressState extends Equatable {
  const GetUserAddressState();
  @override
  List<Object> get props => [];
}

class GetUserAddressInitial extends GetUserAddressState {}

class GetUserAddressLoading extends GetUserAddressState {}

class GetUserAddressLoaded extends GetUserAddressState {
  final List<UserAddress> addresses;
  const GetUserAddressLoaded(this.addresses);
  @override
  List<Object> get props => [addresses];
}

class GetUserAddressEmpty extends GetUserAddressState {}

class GetUserAddressError extends GetUserAddressState {
  final String message;
  const GetUserAddressError(this.message);
  @override
  List<Object> get props => [message];
}

// --- BLoC ---
class GetUserAddressBloc extends Bloc<GetUserAddressEvent, GetUserAddressState> {
  final GetUserAddressService _service;

  GetUserAddressBloc({required GetUserAddressService service})
      : _service = service,
        super(GetUserAddressInitial()) {
    on<FetchUserAddresses>(_onFetchUserAddresses);
  }

  Future<void> _onFetchUserAddresses(
      FetchUserAddresses event,
      Emitter<GetUserAddressState> emit,
      ) async {
    emit(GetUserAddressLoading());
    try {
      final addresses = await _service.fetchUserAddresses(event.userId);

      if (addresses.isEmpty) {
        emit(GetUserAddressEmpty());
      } else {
        emit(GetUserAddressLoaded(addresses));
      }
    } catch (e) {
      emit(GetUserAddressError(e.toString()));
    }
  }
}