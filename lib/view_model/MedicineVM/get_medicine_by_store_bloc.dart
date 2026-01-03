import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/medicine_service/get_medicine_by_store_service.dart';
import '../../models/MedicineM/store_medicine_model.dart';
// --- Events ---
abstract class GetMedicineByStoreEvent {}

class FetchMedicineByStore extends GetMedicineByStoreEvent {
  final int storeId;
  FetchMedicineByStore(this.storeId);
}

// --- States ---
abstract class GetMedicineByStoreState {}

class GetMedicineByStoreInitial extends GetMedicineByStoreState {}

class GetMedicineByStoreLoading extends GetMedicineByStoreState {}

class GetMedicineByStoreLoaded extends GetMedicineByStoreState {
  final List<StoreMedicineModel> medicines;
  GetMedicineByStoreLoaded(this.medicines);
}

class GetMedicineByStoreError extends GetMedicineByStoreState {
  final String message;
  GetMedicineByStoreError(this.message);
}

// --- Bloc ---
class GetMedicineByStoreBloc extends Bloc<GetMedicineByStoreEvent, GetMedicineByStoreState> {
  final GetMedicineByStoreService service;

  GetMedicineByStoreBloc(this.service) : super(GetMedicineByStoreInitial()) {
    on<FetchMedicineByStore>((event, emit) async {
      emit(GetMedicineByStoreLoading());
      try {
        final data = await service.fetchMedicinesByStore(event.storeId);
        emit(GetMedicineByStoreLoaded(data));
      } catch (e) {
        emit(GetMedicineByStoreError(e.toString()));
      }
    });
  }
}