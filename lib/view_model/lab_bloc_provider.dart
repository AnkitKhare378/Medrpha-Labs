import 'package:flutter_bloc/flutter_bloc.dart';

class LabState {
  final Map<String, String>? selectedLab;

  LabState({this.selectedLab});

  LabState copyWith({Map<String, String>? selectedLab}) {
    return LabState(
      selectedLab: selectedLab ?? this.selectedLab,
    );
  }
}

class LabCubit extends Cubit<LabState> {
  LabCubit() : super(LabState());

  void selectLab(Map<String, String> lab) {
    emit(state.copyWith(selectedLab: lab));
  }
}
