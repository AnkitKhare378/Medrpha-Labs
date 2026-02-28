// get_all_banner_view_model.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/all_banner_service/get_all_banner_service.dart';
import '../../models/BannerM/get_all_banner_model.dart';

// --- Events ---
abstract class GetAllBannerEvent extends Equatable {
  const GetAllBannerEvent();

  @override
  List<Object> get props => [];
}

class FetchBanners extends GetAllBannerEvent {
  const FetchBanners();
}

// --- States ---
abstract class GetAllBannerState extends Equatable {
  const GetAllBannerState();

  @override
  List<Object> get props => [];
}

class GetAllBannerInitial extends GetAllBannerState {}

class GetAllBannerLoading extends GetAllBannerState {}

class GetAllBannerLoaded extends GetAllBannerState {
  final List<GetAllBannerModel> banners;

  const GetAllBannerLoaded({required this.banners});

  @override
  List<Object> get props => [banners];
}

class GetAllBannerError extends GetAllBannerState {
  final String message;

  const GetAllBannerError({required this.message});

  @override
  List<Object> get props => [message];
}

// --- BLoC ---
class GetAllBannerBloc extends Bloc<GetAllBannerEvent, GetAllBannerState> {
  final GetAllBannerService _service;

  GetAllBannerBloc(this._service) : super(GetAllBannerInitial()) {
    // Register handler for FetchBanners event
    on<FetchBanners>(_onFetchBanners);
  }

  void _onFetchBanners(
      FetchBanners event,
      Emitter<GetAllBannerState> emit,
      ) async {
    // 1. Emit Loading state
    emit(GetAllBannerLoading());

    try {
      // 2. Call the service to fetch data
      final banners = await _service.fetchAllBanners();

      // 3. Emit Loaded state with the data
      emit(GetAllBannerLoaded(banners: banners));
    } catch (e) {
      // 4. Emit Error state if anything goes wrong
      emit(GetAllBannerError(
          message: 'Failed to fetch banners: ${e.toString()}'));
    }
  }
}