// lib/view_model/BloodVM/get_blood_view_model.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/blood_service/get_blood_service.dart';
import '../../models/BloodM/get_blood_model.dart';

// --- Events ---
abstract class GetBloodGroupEvent {
  const GetBloodGroupEvent();
}

class FetchBloodGroups extends GetBloodGroupEvent {
  const FetchBloodGroups();
}

// --- States ---
abstract class GetBloodGroupState {
  const GetBloodGroupState();
}

class GetBloodGroupInitial extends GetBloodGroupState {}

class GetBloodGroupLoading extends GetBloodGroupState {}

class GetBloodGroupLoaded extends GetBloodGroupState {
  final List<GetBloodGroupModel> bloodGroups;
  const GetBloodGroupLoaded(this.bloodGroups);
}

class GetBloodGroupError extends GetBloodGroupState {
  final String message;
  const GetBloodGroupError(this.message);
}

// --- BLoC ---
class GetBloodGroupBloc extends Bloc<GetBloodGroupEvent, GetBloodGroupState> {
  final GetBloodGroupService _service;

  GetBloodGroupBloc(this._service) : super(GetBloodGroupInitial()) {
    on<FetchBloodGroups>(_onFetchBloodGroups);
  }

  Future<void> _onFetchBloodGroups(
      FetchBloodGroups event, Emitter<GetBloodGroupState> emit) async {
    emit(GetBloodGroupLoading());
    try {
      final bloodGroups = await _service.fetchBloodGroups();
      emit(GetBloodGroupLoaded(bloodGroups));
    } catch (e) {
      emit(GetBloodGroupError(e.toString()));
    }
  }
}