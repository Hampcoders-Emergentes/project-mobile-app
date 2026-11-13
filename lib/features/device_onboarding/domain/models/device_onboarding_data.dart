class DeviceOnboardingRequest {
  final String deviceType;
  final double nominalVoltage;
  final double dailyUsageHours;
  final int occupants;
  final String locationType;
  final String primaryUse;

  const DeviceOnboardingRequest({
    required this.deviceType,
    required this.nominalVoltage,
    required this.dailyUsageHours,
    required this.occupants,
    required this.locationType,
    required this.primaryUse,
  });

  Map<String, dynamic> toJson() => {
    'deviceType': deviceType,
    'nominalVoltage': nominalVoltage,
    'dailyUsageHours': dailyUsageHours,
    'occupants': occupants,
    'locationType': locationType,
    'primaryUse': primaryUse,
  };
}

class SuggestedThresholds {
  final double nominalVoltage;
  final double maxConsumptionWatts;
  final double maxCurrentAmps;
  final double minPowerFactor;
  final double nominalFrequency;
  final int disconnectionThresholdMin;
  final double normalLimitAmps;
  final double alertLimitAmps;

  const SuggestedThresholds({
    required this.nominalVoltage,
    required this.maxConsumptionWatts,
    required this.maxCurrentAmps,
    required this.minPowerFactor,
    required this.nominalFrequency,
    required this.disconnectionThresholdMin,
    this.normalLimitAmps = 0.20,
    this.alertLimitAmps = 0.60,
  });

  factory SuggestedThresholds.fromJson(Map<String, dynamic> json) =>
      SuggestedThresholds(
        nominalVoltage: (json['nominalVoltage'] as num).toDouble(),
        maxConsumptionWatts: (json['maxConsumptionWatts'] as num).toDouble(),
        maxCurrentAmps: (json['maxCurrentAmps'] as num).toDouble(),
        minPowerFactor: (json['minPowerFactor'] as num).toDouble(),
        nominalFrequency: (json['nominalFrequency'] as num).toDouble(),
        disconnectionThresholdMin: json['disconnectionThresholdMin'] as int,
        normalLimitAmps: (json['normalLimitAmps'] as num?)?.toDouble() ?? 0.20,
        alertLimitAmps: (json['alertLimitAmps'] as num?)?.toDouble() ?? 0.60,
      );

  Map<String, dynamic> toThresholdsMap() => {
    'nominalVoltage': nominalVoltage,
    'maxConsumptionWatts': maxConsumptionWatts,
    'maxCurrentAmps': maxCurrentAmps,
    'minPowerFactor': minPowerFactor,
    'nominalFrequency': nominalFrequency,
    'disconnectionThresholdMin': disconnectionThresholdMin,
    'normalLimitAmps': normalLimitAmps,
    'alertLimitAmps': alertLimitAmps,
  };
}

class DeviceOnboardingAnalysis {
  final String reasoning;
  final String narrative;
  final SuggestedThresholds suggestedThresholds;
  final String? analysisId;

  const DeviceOnboardingAnalysis({
    required this.reasoning,
    this.narrative = '',
    required this.suggestedThresholds,
    this.analysisId,
  });

  factory DeviceOnboardingAnalysis.fromJson(Map<String, dynamic> json) =>
      DeviceOnboardingAnalysis(
        reasoning: json['reasoning'] as String? ?? '',
        narrative: json['narrative'] as String? ?? '',
        suggestedThresholds:
            SuggestedThresholds.fromJson(json['suggestedThresholds'] as Map<String, dynamic>),
        analysisId: json['analysisId'] as String?,
      );

  DeviceOnboardingAnalysis copyWith({
    String? reasoning,
    String? narrative,
    SuggestedThresholds? suggestedThresholds,
    String? analysisId,
  }) {
    return DeviceOnboardingAnalysis(
      reasoning: reasoning ?? this.reasoning,
      narrative: narrative ?? this.narrative,
      suggestedThresholds: suggestedThresholds ?? this.suggestedThresholds,
      analysisId: analysisId ?? this.analysisId,
    );
  }
}
