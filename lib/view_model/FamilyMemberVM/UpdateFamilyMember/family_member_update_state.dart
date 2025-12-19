// File: lib/view_model/FamilyMemberVM/FamilyMemberUpdate/family_member_update_state.dart

import 'package:equatable/equatable.dart';
import '../../../../models/FamilyMemberM/family_member_update_response.dart';

abstract class FamilyMemberUpdateState extends Equatable {
  const FamilyMemberUpdateState();

  @override
  List<Object> get props => [];
}

class FamilyMemberUpdateInitial extends FamilyMemberUpdateState {}

class FamilyMemberUpdateLoading extends FamilyMemberUpdateState {}

class FamilyMemberUpdateSuccess extends FamilyMemberUpdateState {
  final FamilyMemberUpdateResponse response;

  const FamilyMemberUpdateSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class FamilyMemberUpdateError extends FamilyMemberUpdateState {
  final String message;

  const FamilyMemberUpdateError(this.message);

  @override
  List<Object> get props => [message];
}