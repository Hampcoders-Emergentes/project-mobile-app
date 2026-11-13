import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/models/device_onboarding_data.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final ApiClient _client;

  OnboardingRepositoryImpl(this._client);

  @override
  Future<DeviceOnboardingAnalysis> analyze(DeviceOnboardingRequest request) async {
    try {
      final response = await _client.post(
        ApiEndpoints.analyzeOnboarding,
        data: request.toJson(),
      );
      return DeviceOnboardingAnalysis.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Error al analizar el dispositivo: ${e.message}');
    }
  }

  @override
  Future<void> confirmThresholds(String profileId, SuggestedThresholds thresholds) async {
    try {
      await _client.put(
        ApiEndpoints.thresholds(profileId),
        data: {'thresholds': thresholds.toThresholdsMap()},
      );
    } on DioException catch (e) {
      throw Exception('Error al guardar umbrales: ${e.message}');
    }
  }

  @override
  Future<DeviceOnboardingAnalysis> adjustAnalysis(String analysisId, String userMessage) async {
    try {
      final response = await _client.post(
        ApiEndpoints.adjustOnboarding,
        data: {
          'analysisId': analysisId,
          'userMessage': userMessage,
        },
      );
      return DeviceOnboardingAnalysis.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Error al ajustar: ${e.message}');
    }
  }
}
