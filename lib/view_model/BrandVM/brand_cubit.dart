// File: lib/view_model/BrandVM/brand_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medrpha_labs/view_model/BrandVM/brand_state.dart';

import '../../data/repositories/brand_service/brand_service.dart';

class BrandCubit extends Cubit<BrandState> {
  final BrandService _service;

  BrandCubit(this._service) : super(BrandInitial());

  Future<void> fetchBrands() async {
    emit(BrandLoading());
    try {
      final brands = await _service.fetchAllBrands();
      emit(BrandLoaded(brands));
    } catch (e) {
      // Catch specific errors if needed, otherwise use a generic message
      emit(BrandError('Failed to fetch brands. Error: ${e.toString()}'));
    }
  }
}