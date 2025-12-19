

import '../../models/BrandM/brand_model.dart';

abstract class BrandState {}

class BrandInitial extends BrandState {}

class BrandLoading extends BrandState {}

class BrandLoaded extends BrandState {
  final List<BrandModel> brands;
  BrandLoaded(this.brands);
}

class BrandError extends BrandState {
  final String message;
  BrandError(this.message);
}