import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/package_service/package_service.dart';
import '../../models/PackagesM/package_model.dart';

abstract class PackageEvent extends Equatable {
  const PackageEvent();
  @override
  List<Object> get props => [];
}

class FetchPackages extends PackageEvent {}

abstract class PackageState extends Equatable {
  const PackageState();
  @override
  List<Object> get props => [];
}

class PackageInitial extends PackageState {}

class PackageLoading extends PackageState {}

class PackageLoaded extends PackageState {
  final List<PackageModel> packages;
  const PackageLoaded(this.packages);

  @override
  List<Object> get props => [packages];
}

class PackageError extends PackageState {
  final String message;
  const PackageError(this.message);

  @override
  List<Object> get props => [message];
}

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  final PackageService _packageService = PackageService();

  PackageBloc() : super(PackageInitial()) {
    on<FetchPackages>(_onFetchPackages);
  }

  void _onFetchPackages(FetchPackages event, Emitter<PackageState> emit) async {
    emit(PackageLoading());
    try {
      final packages = await _packageService.fetchPackages();
      emit(PackageLoaded(packages));
    } catch (e) {
      emit(PackageError("Failed to load packages: ${e.toString()}"));
    }
  }
}