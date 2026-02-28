import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/company_service/get_all_company_service.dart';
import '../../models/CompanyM/company_model.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final CompanyService _service;

  CompanyBloc(this._service) : super(CompanyInitial()) {
    on<FetchCompaniesEvent>((event, emit) async {
      emit(CompanyLoading());
      try {
        final companies = await _service.getAllCompanies();
        emit(CompanyLoaded(companies));
      } catch (e) {
        emit(CompanyError(e.toString()));
      }
    });
  }
}

// Events
abstract class CompanyEvent {}
class FetchCompaniesEvent extends CompanyEvent {}

// States
abstract class CompanyState {}
class CompanyInitial extends CompanyState {}
class CompanyLoading extends CompanyState {}
class CompanyLoaded extends CompanyState {
  final List<CompanyModel> companies;
  CompanyLoaded(this.companies);
}
class CompanyError extends CompanyState {
  final String message;
  CompanyError(this.message);
}