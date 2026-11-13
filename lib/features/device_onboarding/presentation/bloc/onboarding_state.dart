import 'package:equatable/equatable.dart';
import '../../domain/models/device_onboarding_data.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingStep1DeviceInfo extends OnboardingState {}

class OnboardingStep2Analyzing extends OnboardingState {
  final DeviceOnboardingRequest request;

  const OnboardingStep2Analyzing(this.request);

  @override
  List<Object?> get props => [request];
}

class OnboardingStep2AnalysisResult extends OnboardingState {
  final DeviceOnboardingRequest request;
  final DeviceOnboardingAnalysis analysis;

  const OnboardingStep2AnalysisResult({
    required this.request,
    required this.analysis,
  });

  @override
  List<Object?> get props => [request, analysis];
}

class OnboardingStep3Adjusting extends OnboardingState {
  final DeviceOnboardingAnalysis analysis;

  const OnboardingStep3Adjusting(this.analysis);

  @override
  List<Object?> get props => [analysis];
}

class OnboardingCompleted extends OnboardingState {
  final String message;

  const OnboardingCompleted(this.message);

  @override
  List<Object?> get props => [message];
}

class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object?> get props => [message];
}

class OnboardingConfirming extends OnboardingState {
  final DeviceOnboardingAnalysis analysis;

  const OnboardingConfirming(this.analysis);

  @override
  List<Object?> get props => [analysis];
}

class OnboardingConfirmError extends OnboardingState {
  final DeviceOnboardingAnalysis analysis;
  final String message;

  const OnboardingConfirmError(this.analysis, this.message);

  @override
  List<Object?> get props => [analysis, message];
}

class OnboardingAdjustingWithAI extends OnboardingState {
  final DeviceOnboardingAnalysis currentAnalysis;

  const OnboardingAdjustingWithAI(this.currentAnalysis);

  @override
  List<Object?> get props => [currentAnalysis];
}

class OnboardingAdjustError extends OnboardingState {
  final DeviceOnboardingAnalysis currentAnalysis;
  final String message;

  const OnboardingAdjustError(this.currentAnalysis, this.message);

  @override
  List<Object?> get props => [currentAnalysis, message];
}
