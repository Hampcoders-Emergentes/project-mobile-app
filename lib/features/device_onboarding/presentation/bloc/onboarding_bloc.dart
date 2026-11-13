import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/device_onboarding_data.dart';
import '../../domain/repositories/onboarding_repository.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository _repository;
  DeviceOnboardingAnalysis? _lastAnalysis;

  OnboardingBloc(this._repository) : super(OnboardingInitial()) {
    on<SubmitDeviceInfo>(_onSubmitDeviceInfo);
    on<AdjustThreshold>(_onAdjustThreshold);
    on<ConfirmThresholds>(_onConfirmThresholds);
    on<AdjustWithAI>(_onAdjustWithAI);
    on<ResetOnboarding>((_, emit) => emit(OnboardingInitial()));
  }

  Future<void> _onSubmitDeviceInfo(
    SubmitDeviceInfo event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingStep2Analyzing(event.request));

    try {
      final analysis = await _repository.analyze(event.request);
      _lastAnalysis = analysis;
      emit(OnboardingStep2AnalysisResult(
        request: event.request,
        analysis: analysis,
      ));
    } catch (e) {
      emit(OnboardingError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void _onAdjustThreshold(
    AdjustThreshold event,
    Emitter<OnboardingState> emit,
  ) {
    if (_lastAnalysis == null) return;

    final current = _lastAnalysis!.suggestedThresholds;

    final updated = SuggestedThresholds(
      nominalVoltage: event.field == 'nominalVoltage'
          ? (event.value as num).toDouble()
          : current.nominalVoltage,
      maxConsumptionWatts: event.field == 'maxConsumptionWatts'
          ? (event.value as num).toDouble()
          : current.maxConsumptionWatts,
      maxCurrentAmps: event.field == 'maxCurrentAmps'
          ? (event.value as num).toDouble()
          : current.maxCurrentAmps,
      minPowerFactor: event.field == 'minPowerFactor'
          ? (event.value as num).toDouble()
          : current.minPowerFactor,
      nominalFrequency: event.field == 'nominalFrequency'
          ? (event.value as num).toDouble()
          : current.nominalFrequency,
      disconnectionThresholdMin: event.field == 'disconnectionThresholdMin'
          ? (event.value as int)
          : current.disconnectionThresholdMin,
    );

    _lastAnalysis = _lastAnalysis!.copyWith(
      suggestedThresholds: updated,
    );

    emit(OnboardingStep3Adjusting(_lastAnalysis!));
  }

  Future<void> _onConfirmThresholds(
    ConfirmThresholds event,
    Emitter<OnboardingState> emit,
  ) async {
    if (_lastAnalysis == null) return;

    emit(OnboardingConfirming(_lastAnalysis!));

    try {
      await _repository.confirmThresholds(
        event.profileId,
        _lastAnalysis!.suggestedThresholds,
      );
      emit(const OnboardingCompleted(
          'Dispositivo configurado correctamente'));
    } catch (e) {
      emit(OnboardingConfirmError(
        _lastAnalysis!,
        e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> _onAdjustWithAI(
    AdjustWithAI event,
    Emitter<OnboardingState> emit,
  ) async {
    if (_lastAnalysis == null) return;

    emit(OnboardingAdjustingWithAI(_lastAnalysis!));

    try {
      final analysis = await _repository.adjustAnalysis(
        event.analysisId,
        event.userMessage,
      );
      _lastAnalysis = analysis;
      emit(OnboardingStep3Adjusting(analysis));
    } catch (e) {
      emit(OnboardingAdjustError(
        _lastAnalysis!,
        e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}
