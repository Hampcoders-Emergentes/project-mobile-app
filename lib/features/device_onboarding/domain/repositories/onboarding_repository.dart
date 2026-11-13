import '../models/device_onboarding_data.dart';

abstract class OnboardingRepository {
  Future<DeviceOnboardingAnalysis> analyze(DeviceOnboardingRequest request);

  Future<void> confirmThresholds(String profileId, SuggestedThresholds thresholds);

  Future<DeviceOnboardingAnalysis> adjustAnalysis(String analysisId, String userMessage);
}
