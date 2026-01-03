import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../config/apiConstant/api_constant.dart';
import '../../core/network/api_call.dart';
import '../../models/MedicineM/get_medicine_by_company_model.dart';
import '../../models/MedicineM/get_medicine_by_company_service.dart';

abstract class GetMedicineByCompanyEvent extends Equatable {
  const GetMedicineByCompanyEvent();

  @override
  List<Object> get props => [];
}

/// Event to initiate fetching medicines for a specific company ID.
class FetchMedicineByCompany extends GetMedicineByCompanyEvent {
  final int companyId;

  const FetchMedicineByCompany(this.companyId);

  @override
  List<Object> get props => [companyId];
}

abstract class GetMedicineByCompanyState extends Equatable {
  const GetMedicineByCompanyState();

  @override
  List<Object> get props => [];
}

/// Initial state before any operation is performed.
class GetMedicineByCompanyInitial extends GetMedicineByCompanyState {}

/// State while fetching data.
class GetMedicineByCompanyLoading extends GetMedicineByCompanyState {}

/// State when data fetching is successful.
class GetMedicineByCompanyLoaded extends GetMedicineByCompanyState {
  final List<GetMedicineByCompanyModel1> medicines;

  const GetMedicineByCompanyLoaded(this.medicines);

  @override
  List<Object> get props => [medicines];
}

/// State when an error occurs during fetching.
class GetMedicineByCompanyError extends GetMedicineByCompanyState {
  final String message;

  const GetMedicineByCompanyError(this.message);

  @override
  List<Object> get props => [message];
}

// get_medicine_by_company_service.dart (Updated Implementation)

// Assuming the API returns a List of medicine objects.


class GetMedicineByCompanyBloc extends Bloc<GetMedicineByCompanyEvent, GetMedicineByCompanyState> {
  final GetMedicineByCompanyService _service;

  GetMedicineByCompanyBloc(this._service) : super(GetMedicineByCompanyInitial()) {
    on<FetchMedicineByCompany>(_onFetchMedicineByCompany);
  }

  void _onFetchMedicineByCompany(
      FetchMedicineByCompany event,
      Emitter<GetMedicineByCompanyState> emit,
      ) async {
    // 1. Emit Loading state
    emit(GetMedicineByCompanyLoading());
    try {
      // 2. Call the service
      final medicines = await _service.fetchMedicineByCompany(event.companyId);

      // 3. Emit Loaded state with the data
      emit(GetMedicineByCompanyLoaded(medicines));
    } catch (e) {
      // 4. Emit Error state if the service call fails
      emit(GetMedicineByCompanyError(e.toString()));
    }
  }
}