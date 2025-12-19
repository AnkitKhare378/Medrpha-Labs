import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/customer_service/customer_service.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerService customerService;

  CustomerBloc(this.customerService) : super(CustomerInitial()) {
    on<FetchCustomerEvent>(_onFetchCustomer);
  }

  void _onFetchCustomer(
      FetchCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    try {
      final response = await customerService.fetchCustomerById(event.customerId);

      if (response.succeeded && response.data != null) {
        emit(CustomerLoaded(response.data!));
      } else {
        emit(CustomerError(response.message));
      }
    } catch (e) {
      emit(CustomerError('Failed to fetch customer data: ${e.toString()}'));
    }
  }
}