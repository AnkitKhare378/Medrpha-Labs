// lib/view_model/CustomerVM/edit_profile_cubit.dart (MODIFIED)

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/customer_service/edit_profile_service.dart';
import '../../models/CustomerM/update_customer_response_model.dart';

// --- States (Remains the same) ---
abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}
class EditProfileLoading extends EditProfileState {}
class EditProfileSuccess extends EditProfileState {
  final CustomerData customer;
  final String? message;
  EditProfileSuccess(this.customer, {this.message});
}
class EditProfileFailure extends EditProfileState {
  final String message;
  EditProfileFailure(this.message);
}

// --- Cubit (Updated) ---
class EditProfileCubit extends Cubit<EditProfileState> {
  final EditProfileService _service;

  EditProfileCubit(this._service) : super(EditProfileInitial());

  Future<void> updateCustomer({
    required int id,
    required String customerName,
    required String emailId,
    required String phoneNumber,
    String? photoPath, // ⬅️ ADDED: Optional file path
  }) async {
    emit(EditProfileLoading());

    try {
      // 1. Call the dedicated service method with the photoPath
      final UpdateCustomerResponse updateResponse = await _service.updateCustomer(
        id: id,
        customerName: customerName,
        emailId: emailId,
        phoneNumber: phoneNumber,
        photoPath: photoPath, // ⬅️ Passed to service
      );

      // 2. Process the response model
      if (updateResponse.succeeded && updateResponse.data != null) {
        emit(EditProfileSuccess(
          updateResponse.data!,
          message: updateResponse.message ?? "Profile updated successfully.",
        ));
      } else {
        emit(EditProfileFailure(
            updateResponse.message ?? "Update failed due to server logic."
        ));
      }
    } catch (e) {
      emit(EditProfileFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}