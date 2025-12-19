// lib/view_model/MedicineVM/MedicineDetail/medicine_detail_view_model.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medrpha_labs/models/MedicineM/get_medicine_by_id_model.dart';

import '../../data/repositories/medicine_service/medicine_by_Id_service.dart';

// --- States ---
abstract class MedicineDetailState extends Equatable {
  const MedicineDetailState();

  @override
  List<Object> get props => [];
}

class MedicineDetailInitial extends MedicineDetailState {}

class MedicineDetailLoading extends MedicineDetailState {}

class MedicineDetailLoaded extends MedicineDetailState {
  final GetMedicineByIdModel medicineDetail;

  const MedicineDetailLoaded({required this.medicineDetail});

  @override
  List<Object> get props => [medicineDetail];
}

class MedicineDetailError extends MedicineDetailState {
  final String message;

  const MedicineDetailError({required this.message});

  @override
  List<Object> get props => [message];
}

// --- Cubit ---
class MedicineDetailCubit extends Cubit<MedicineDetailState> {
  final MedicineService _service;

  MedicineDetailCubit(this._service) : super(MedicineDetailInitial());

  Future<void> fetchMedicineDetail(int id) async {
    if (id <= 0) {
      emit(const MedicineDetailError(message: "Invalid medicine ID."));
      return;
    }

    emit(MedicineDetailLoading());
    try {
      final detail = await _service.getMedicineById(id);
      emit(MedicineDetailLoaded(medicineDetail: detail));
    } catch (e) {
      // Log the full error if needed
      print("Error fetching medicine detail: $e");
      emit(MedicineDetailError(message: e.toString().contains("Exception:")
          ? e.toString().split("Exception: ")[1]
          : "Could not fetch medicine detail."
      ));
    }
  }
}