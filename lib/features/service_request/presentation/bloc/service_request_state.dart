import 'package:equatable/equatable.dart';

class ServiceRequestState extends Equatable {
  final int currentStep;
  final String selectedProperty;
  final int selectedServiceCategory;

  const ServiceRequestState({
    this.currentStep = 2,
    this.selectedProperty = 'Casa Principal',
    this.selectedServiceCategory = 0,
  });

  ServiceRequestState copyWith({
    int? currentStep,
    String? selectedProperty,
    int? selectedServiceCategory,
  }) {
    return ServiceRequestState(
      currentStep: currentStep ?? this.currentStep,
      selectedProperty: selectedProperty ?? this.selectedProperty,
      selectedServiceCategory: selectedServiceCategory ?? this.selectedServiceCategory,
    );
  }

  @override
  List<Object> get props => [currentStep, selectedProperty, selectedServiceCategory];
}
