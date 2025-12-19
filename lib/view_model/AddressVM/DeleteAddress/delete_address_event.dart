// lib/view_model/AddressVM/DeleteUserAddress/delete_address_event.dart

abstract class DeleteAddressEvent {}

class DeleteUserAddress extends DeleteAddressEvent {
  final String addressId;

  DeleteUserAddress(this.addressId);
}