import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object> get props => [];
}

class SelectPeriod extends AnalyticsEvent {
  final int index;

  const SelectPeriod({required this.index});

  @override
  List<Object> get props => [index];
}
