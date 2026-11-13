import 'package:equatable/equatable.dart';
import '../../domain/models/device_onboarding_data.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class SubmitDeviceInfo extends OnboardingEvent {
  final DeviceOnboardingRequest request;

  const SubmitDeviceInfo(this.request);

  @override
  List<Object?> get props => [request];
}

class AdjustThreshold extends OnboardingEvent {
  final String field;
  final dynamic value;

  const AdjustThreshold(this.field, this.value);

  @override
  List<Object?> get props => [field, value];
}

class ConfirmThresholds extends OnboardingEvent {
  final String profileId;

  const ConfirmThresholds(this.profileId);

  @override
  List<Object?> get props => [profileId];
}

class AdjustWithAI extends OnboardingEvent {
  final String analysisId;
  final String userMessage;

  const AdjustWithAI({required this.analysisId, required this.userMessage});

  @override
  List<Object?> get props => [analysisId, userMessage];
}

class ResetOnboarding extends OnboardingEvent {}
