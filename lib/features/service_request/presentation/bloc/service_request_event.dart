import 'package:equatable/equatable.dart';

abstract class ServiceRequestEvent extends Equatable {
  const ServiceRequestEvent();

  @override
  List<Object> get props => [];
}

class SelectProperty extends ServiceRequestEvent {
  final String property;

  const SelectProperty({required this.property});

  @override
  List<Object> get props => [property];
}

class SelectServiceCategory extends ServiceRequestEvent {
  final int index;

  const SelectServiceCategory({required this.index});

  @override
  List<Object> get props => [index];
}

class GoToStep extends ServiceRequestEvent {
  final int step;

  const GoToStep({required this.step});

  @override
  List<Object> get props => [step];
}
