import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/medicine_service/category_medicine_service.dart';
import '../../models/MedicineM/category_medicine_model.dart';

// --- Events ---
abstract class CategoryMedicineEvent {}

class FetchMedicines extends CategoryMedicineEvent {
  final int id;
  final MedicineFetchType type;
  FetchMedicines({required this.id, required this.type});
}

// --- States ---
abstract class CategoryMedicineState {}

class CategoryMedicineInitial extends CategoryMedicineState {}
class CategoryMedicineLoading extends CategoryMedicineState {}
class CategoryMedicineLoaded extends CategoryMedicineState {
  final List<CategoryMedicineModel> medicines;
  CategoryMedicineLoaded(this.medicines);
}
class CategoryMedicineError extends CategoryMedicineState {
  final String message;
  CategoryMedicineError(this.message);
}

// --- Bloc ---
class CategoryMedicineBloc extends Bloc<CategoryMedicineEvent, CategoryMedicineState> {
  final CategoryMedicineService service;

  CategoryMedicineBloc(this.service) : super(CategoryMedicineInitial()) {
    on<FetchMedicines>((event, emit) async {
      emit(CategoryMedicineLoading());
      try {
        final medicines = await service.fetchMedicines(
          id: event.id,
          type: event.type,
        );
        emit(CategoryMedicineLoaded(medicines));
      } catch (e) {
        // Cleaning up the error message for the UI
        emit(CategoryMedicineError(e.toString().replaceAll("Exception:", "")));
      }
    });
  }
}