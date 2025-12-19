// lib/view_model/AddressVM/DeleteUserAddress/delete_address_state.dart

abstract class DeleteAddressState {}

class DeleteAddressInitial extends DeleteAddressState {}

class DeleteAddressLoading extends DeleteAddressState {}

class DeleteAddressSuccess extends DeleteAddressState {
  final String message;
  DeleteAddressSuccess(this.message);
}

class DeleteAddressError extends DeleteAddressState {
  final String message;
  DeleteAddressError(this.message);
}