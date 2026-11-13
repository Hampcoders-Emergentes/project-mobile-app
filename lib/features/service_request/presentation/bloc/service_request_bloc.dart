import 'package:flutter_bloc/flutter_bloc.dart';
import 'service_request_event.dart';
import 'service_request_state.dart';

class ServiceRequestBloc extends Bloc<ServiceRequestEvent, ServiceRequestState> {
  ServiceRequestBloc() : super(const ServiceRequestState()) {
    on<SelectProperty>(_onSelectProperty);
    on<SelectServiceCategory>(_onSelectServiceCategory);
    on<GoToStep>(_onGoToStep);
  }

  void _onSelectProperty(SelectProperty event, Emitter<ServiceRequestState> emit) {
    emit(state.copyWith(selectedProperty: event.property));
  }

  void _onSelectServiceCategory(
    SelectServiceCategory event,
    Emitter<ServiceRequestState> emit,
  ) {
    emit(state.copyWith(selectedServiceCategory: event.index));
  }

  void _onGoToStep(GoToStep event, Emitter<ServiceRequestState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }
}
