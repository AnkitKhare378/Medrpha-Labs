import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/package_service/package_detail_service.dart';
import '../../models/PackagesM/package_detail_model.dart';

// --- Events ---
abstract class PackageDetailEvent extends Equatable {
  const PackageDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchPackageDetail extends PackageDetailEvent {
  final int packageId;

  const FetchPackageDetail(this.packageId);

  @override
  List<Object> get props => [packageId];
}

// --- States ---
abstract class PackageDetailState extends Equatable {
  const PackageDetailState();

  @override
  List<Object> get props => [];
}

class PackageDetailInitial extends PackageDetailState {}

class PackageDetailLoading extends PackageDetailState {}

class PackageDetailLoaded extends PackageDetailState {
  final PackageDetailModel packageDetail;

  const PackageDetailLoaded(this.packageDetail);

  @override
  List<Object> get props => [packageDetail];
}

class PackageDetailError extends PackageDetailState {
  final String message;

  const PackageDetailError(this.message);

  @override
  List<Object> get props => [message];
}

// --- BLoC ---
class PackageDetailBloc extends Bloc<PackageDetailEvent, PackageDetailState> {
  final PackageDetailService _service;

  PackageDetailBloc(this._service) : super(PackageDetailInitial()) {
    on<FetchPackageDetail>(_onFetchPackageDetail);
  }

  void _onFetchPackageDetail(
      FetchPackageDetail event,
      Emitter<PackageDetailState> emit,
      ) async {
    emit(PackageDetailLoading());
    try {
      final packageDetail = await _service.getPackageDetail(event.packageId);
      emit(PackageDetailLoaded(packageDetail));
    } catch (e) {
      emit(PackageDetailError(e.toString()));
    }
  }
}