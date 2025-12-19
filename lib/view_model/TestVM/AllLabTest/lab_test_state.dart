import 'package:equatable/equatable.dart';
import 'package:medrpha_labs/models/TestM/lab_test.dart';

abstract class AllTestState extends Equatable{
  const AllTestState();

  @override
  List<Object> get props => [];
}

class AllTestInitial extends AllTestState {}

class AllTestLoading extends AllTestState{}

class AllTestLoaded extends AllTestState{
  final List<LabTest> test;

  const AllTestLoaded(this.test);
}

class AllTestError extends AllTestState {
  final String message;

  const AllTestError(this.message);

  @override
  List<Object> get props => [message];
}