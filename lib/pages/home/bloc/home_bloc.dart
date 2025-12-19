import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../view_model/home_view_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeViewModel viewModel;

  HomeBloc(this.viewModel) : super(HomeInitial()) {
    on<LoadUserEvent>((event, emit) async {
      emit(HomeLoading());
      final result = await viewModel.fetchUser(event.userId);
      result.fold(
            (failure) => emit(HomeError(failure.message)),
            (user) => emit(HomeLoaded(user)),
      );
    });
  }
}
