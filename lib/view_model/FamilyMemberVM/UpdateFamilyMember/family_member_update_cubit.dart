// File: lib/view_model/FamilyMemberVM/FamilyMemberUpdate/family_member_update_cubit.dart

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'family_member_update_state.dart';
import '../../../../data/repositories/family_member_service/family_member_update_service.dart'; // Adjust path

class FamilyMemberUpdateCubit extends Cubit<FamilyMemberUpdateState> {
  final FamilyMemberUpdateService _service;

  FamilyMemberUpdateCubit({required FamilyMemberUpdateService service})
      : _service = service,
        super(FamilyMemberUpdateInitial());

  Future<void> updateMember({
    required int id,
    required String userId, // This must be provided, typically from Auth state
    required String firstName,
    required String lastName,
    required String age,
    required String relationId,
    required String gender,
    required String dateOfBirth,
    required String heightCM,
    required String weightKG,
    required String bloodGroup,
    required String address,
    required File? photoFile,
    required String existingPhoto,
  }) async {
    emit(FamilyMemberUpdateLoading());
    try {
      final response = await _service.updateMember(
        id: id,
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        age: age,
        relationId: relationId,
        gender: gender,
        dateOfBirth: dateOfBirth,
        heightCM: heightCM,
        weightKG: weightKG,
        bloodGroup: bloodGroup,
        address: address,
        photoFile: photoFile,
        existingPhoto: existingPhoto,
      );

      if (response.succeeded) {
        emit(FamilyMemberUpdateSuccess(response));
      } else {
        // Handle API success but logic failure (e.g., succeeded: false)
        emit(FamilyMemberUpdateError(response.message));
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(FamilyMemberUpdateError(errorMessage));
    }
  }

  // Utility to reset state after success or error for subsequent updates
  void resetState() {
    emit(FamilyMemberUpdateInitial());
  }
}