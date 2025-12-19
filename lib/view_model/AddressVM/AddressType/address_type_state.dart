part of 'address_type_view_model.dart';


abstract class AddressTypeState {}

class AddressTypeInitial extends AddressTypeState {}

class AddressTypeLoading extends AddressTypeState {}

class AddressTypeLoaded extends AddressTypeState {
  final List<AddressTypeModel> types;
  AddressTypeLoaded(this.types);
}

class AddressTypeError extends AddressTypeState {
  final String message;
  AddressTypeError(this.message);
}
