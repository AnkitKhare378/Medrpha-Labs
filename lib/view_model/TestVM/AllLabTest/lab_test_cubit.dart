import 'package:bloc/bloc.dart';

import '../../../data/repositories/test_service/test_service.dart';
import 'lab_test_state.dart';

class AllTestCubit extends Cubit<AllTestState> {
  final TestService _testService;

  AllTestCubit(this._testService) : super(AllTestInitial());

  Future<void> loadAllTests() async {
    if(state is AllTestLoading || state is AllTestLoaded) return;

    emit(AllTestLoading());
    try{
      final tests = await _testService.fetchAllTests();
      emit(AllTestLoaded(tests));
    }
    catch(e){
      emit(AllTestError("Failed to load lab tests: ${e.toString()}"));
    }
  }

}