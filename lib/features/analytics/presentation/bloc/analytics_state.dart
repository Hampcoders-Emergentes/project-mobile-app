import 'package:equatable/equatable.dart';

class AnalyticsState extends Equatable {
  final int selectedPeriod;

  const AnalyticsState({this.selectedPeriod = 0});

  AnalyticsState copyWith({int? selectedPeriod}) {
    return AnalyticsState(
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
    );
  }

  @override
  List<Object> get props => [selectedPeriod];
}
