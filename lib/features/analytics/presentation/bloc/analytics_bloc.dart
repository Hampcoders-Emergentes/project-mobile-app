import 'package:flutter_bloc/flutter_bloc.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc() : super(const AnalyticsState()) {
    on<SelectPeriod>(_onSelectPeriod);
  }

  void _onSelectPeriod(SelectPeriod event, Emitter<AnalyticsState> emit) {
    emit(state.copyWith(selectedPeriod: event.index));
  }
}
