// File: lib/view_model/FamilyMemberVM/get_family_members/get_family_members_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/FamilyMemberM/get_family_members_model.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/repositories/family_member_service/get_family_members_service.dart';

class GetFamilyMembersCubit extends Cubit<GetFamilyMembersState> {
  final GetFamilyMembersService _service;

  GetFamilyMembersCubit({required GetFamilyMembersService service})
      : _service = service,
        super(GetFamilyMembersInitial());

  /// Fetches family members for the currently logged-in user.
  Future<void> fetchFamilyMembers() async {
    emit(GetFamilyMembersLoading());

    try {
      // 1. Get the current UserId from local storage using getInt
      final prefs = await SharedPreferences.getInstance();

      // 💡 UPDATED LINE: Fetching as int, using key 'user_id'
      final int? rawUserId = prefs.getInt('user_id');

      // Convert the integer ID to a string for the API call
      final String? userId = rawUserId?.toString();

      if (userId == null || userId.isEmpty || userId == '0') {
        emit(const GetFamilyMembersError("User ID not found. Please log in."));
        return;
      }

      // 2. Call the service
      final members = await _service.getMembers(userId);

      emit(GetFamilyMembersLoaded(members));
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(GetFamilyMembersError(errorMessage));
    }
  }

  // Helper method to refresh the list after an insert/update
  Future<void> refreshMembers() => fetchFamilyMembers();
}

// -----------------------------------------------------------------------------
// Note: The contents of get_family_members_state.dart remain unchanged.
// -----------------------------------------------------------------------------

// File: lib/view_model/FamilyMemberVM/get_family_members/get_family_members_state.dart



abstract class GetFamilyMembersState extends Equatable {
  const GetFamilyMembersState();

  @override
  List<Object> get props => [];
}

class GetFamilyMembersInitial extends GetFamilyMembersState {}

class GetFamilyMembersLoading extends GetFamilyMembersState {}

class GetFamilyMembersLoaded extends GetFamilyMembersState {
  final List<FamilyMemberModel> members;

  const GetFamilyMembersLoaded(this.members);

  @override
  List<Object> get props => [members];
}

class GetFamilyMembersError extends GetFamilyMembersState {
  final String message;

  const GetFamilyMembersError(this.message);

  @override
  List<Object> get props => [message];
}