import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medrpha_labs/data/repositories/family_member_service/family_member_delete_service.dart';

// --- States (To be placed in family_member_delete_state.dart) ---
abstract class FamilyMemberDeleteState {}
class FamilyMemberDeleteInitial extends FamilyMemberDeleteState {}
class FamilyMemberDeleteLoading extends FamilyMemberDeleteState {}
class FamilyMemberDeleteSuccess extends FamilyMemberDeleteState {
  final String message;
  FamilyMemberDeleteSuccess(this.message);
}
class FamilyMemberDeleteError extends FamilyMemberDeleteState {
  final String message;
  FamilyMemberDeleteError(this.message);
}
// -----------------------------------------------------------------

class FamilyMemberDeleteCubit extends Cubit<FamilyMemberDeleteState> {
  final FamilyMemberDeleteService _service;

  FamilyMemberDeleteCubit(this._service) : super(FamilyMemberDeleteInitial());

  Future<void> deleteMember(int memberId) async {
    emit(FamilyMemberDeleteLoading());
    try {
      final result = await _service.deleteMember(memberId);
      emit(FamilyMemberDeleteSuccess(result.message));
      // Optionally reset to initial state after a delay or on success
      // Future.delayed(const Duration(seconds: 1), () => emit(FamilyMemberDeleteInitial()));
    } catch (e) {
      emit(FamilyMemberDeleteError(e.toString().contains('Exception:')
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Could not delete member.'));
    }
  }

  void resetState() {
    emit(FamilyMemberDeleteInitial());
  }
}