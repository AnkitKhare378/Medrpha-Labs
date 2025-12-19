// File: lib/view_model/MasterVM/RelationVM/relation_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/family_member_service/relation_service.dart';
import '../../models/FamilyMemberM/relation_model.dart';

abstract class RelationState extends Equatable {
  const RelationState();

  @override
  List<Object> get props => [];
}

class RelationInitial extends RelationState {}

class RelationLoading extends RelationState {}

class RelationLoaded extends RelationState {
  final List<RelationModel> relations;

  const RelationLoaded(this.relations);

  @override
  List<Object> get props => [relations];
}

class RelationError extends RelationState {
  final String message;

  const RelationError(this.message);

  @override
  List<Object> get props => [message];
}

class RelationCubit extends Cubit<RelationState> {
  final RelationService _service;

  RelationCubit({required RelationService service})
      : _service = service,
        super(RelationInitial());

  Future<void> fetchRelations() async {
    emit(RelationLoading());
    try {
      final relations = await _service.getAllRelations();
      emit(RelationLoaded(relations));
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(RelationError(errorMessage));
    }
  }
}