import 'package:equatable/equatable.dart';

/// Umbral para considerar un circuito/dispositivo en línea: si no registra
/// lecturas en más de 5 minutos, la UI lo interpreta como Offline.
const Duration kOnlineThreshold = Duration(minutes: 5);

class TimeSeriesPoint extends Equatable {
  final DateTime timestamp;
  final double kilowattHours;
  final String granularity;

  const TimeSeriesPoint({
    required this.timestamp,
    required this.kilowattHours,
    required this.granularity,
  });

  factory TimeSeriesPoint.fromJson(Map<String, dynamic> json) {
    return TimeSeriesPoint(
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '')?.toUtc() ??
              DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      kilowattHours: (json['kilowattHours'] as num?)?.toDouble() ?? 0,
      granularity: json['granularity'] as String? ?? '',
    );
  }

  @override
  List<Object> get props => [timestamp, kilowattHours, granularity];
}

class CircuitSummary extends Equatable {
  final String circuitId;
  final double totalKilowattHours;
  final double peakVoltage;
  final double peakCurrent;
  final DateTime? lastReadingAt;

  const CircuitSummary({
    required this.circuitId,
    required this.totalKilowattHours,
    required this.peakVoltage,
    required this.peakCurrent,
    this.lastReadingAt,
  });

  factory CircuitSummary.fromJson(Map<String, dynamic> json) {
    return CircuitSummary(
      circuitId: json['circuitId'] as String? ?? '',
      totalKilowattHours:
          (json['totalKilowattHours'] as num?)?.toDouble() ?? 0,
      peakVoltage: (json['peakVoltage'] as num?)?.toDouble() ?? 0,
      peakCurrent: (json['peakCurrent'] as num?)?.toDouble() ?? 0,
      lastReadingAt:
          DateTime.tryParse(json['lastReadingAt'] as String? ?? '')?.toUtc(),
    );
  }

  bool isOnline(DateTime now) =>
      lastReadingAt != null &&
      now.toUtc().difference(lastReadingAt!) <= kOnlineThreshold;

  @override
  List<Object?> get props =>
      [circuitId, totalKilowattHours, peakVoltage, peakCurrent, lastReadingAt];
}

class ConsumptionDashboard extends Equatable {
  final String dashboardId;
  final String ownerId;
  final String propertyId;
  final List<String> deviceIds;
  final String planTier;
  final double totalConsumptionKWh;
  final double costProjectionAmount;
  final String costProjectionCurrency;
  final DateTime? lastUpdatedAt;
  final List<TimeSeriesPoint> timeSeries;
  final List<CircuitSummary> circuitSummaries;

  const ConsumptionDashboard({
    required this.dashboardId,
    required this.ownerId,
    required this.propertyId,
    required this.deviceIds,
    required this.planTier,
    required this.totalConsumptionKWh,
    required this.costProjectionAmount,
    required this.costProjectionCurrency,
    required this.lastUpdatedAt,
    required this.timeSeries,
    required this.circuitSummaries,
  });

  factory ConsumptionDashboard.fromJson(Map<String, dynamic> json) {
    final series = (json['timeSeries'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(TimeSeriesPoint.fromJson)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return ConsumptionDashboard(
      dashboardId: json['dashboardId'] as String? ?? '',
      ownerId: json['ownerId'] as String? ?? '',
      propertyId: json['propertyId'] as String? ?? '',
      deviceIds: (json['deviceIds'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      planTier: json['planTier'] as String? ?? '',
      totalConsumptionKWh:
          (json['totalConsumptionKWh'] as num?)?.toDouble() ?? 0,
      costProjectionAmount:
          (json['costProjectionAmount'] as num?)?.toDouble() ?? 0,
      costProjectionCurrency: json['costProjectionCurrency'] as String? ?? '',
      lastUpdatedAt:
          DateTime.tryParse(json['lastUpdatedAt'] as String? ?? '')?.toUtc(),
      timeSeries: series,
      circuitSummaries: (json['circuitSummaries'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(CircuitSummary.fromJson)
          .toList(),
    );
  }

  /// Variación porcentual del consumo: ventana reciente vs ventana anterior
  /// del mismo tamaño, computada localmente sobre `timeSeries`.
  /// Devuelve null si no hay datos suficientes para comparar.
  double? percentChange(Duration window) {
    if (timeSeries.isEmpty) return null;
    final end = timeSeries.last.timestamp;
    final midpoint = end.subtract(window);
    final start = end.subtract(window * 2);

    double current = 0;
    double previous = 0;
    for (final point in timeSeries) {
      if (point.timestamp.isAfter(midpoint)) {
        current += point.kilowattHours;
      } else if (point.timestamp.isAfter(start)) {
        previous += point.kilowattHours;
      }
    }
    if (previous <= 0) return null;
    return ((current - previous) / previous) * 100;
  }

  int get totalDevices =>
      deviceIds.isNotEmpty ? deviceIds.length : circuitSummaries.length;

  int onlineCircuits(DateTime now) =>
      circuitSummaries.where((c) => c.isOnline(now)).length;

  /// Con la heurística de `lastReadingAt`, los circuitos en línea son el
  /// mejor proxy disponible de dispositivos activos.
  int onlineDevices(DateTime now) {
    if (circuitSummaries.isEmpty) return 0;
    final online = onlineCircuits(now);
    if (deviceIds.isEmpty) return online;
    // Escala proporcionalmente cuando dispositivos y circuitos no van 1 a 1.
    return ((online / circuitSummaries.length) * deviceIds.length).round();
  }

  double get maxPeakVoltage => circuitSummaries.isEmpty
      ? 0
      : circuitSummaries
          .map((c) => c.peakVoltage)
          .reduce((a, b) => a > b ? a : b);

  /// Potencia media estimada (kW) del último intervalo de la serie.
  /// El backend entrega energía (kWh) por intervalo, no potencia instantánea.
  double? get latestPowerKw {
    if (timeSeries.length < 2) return null;
    final last = timeSeries.last;
    final prev = timeSeries[timeSeries.length - 2];
    final hours =
        last.timestamp.difference(prev.timestamp).inSeconds / 3600.0;
    if (hours <= 0) return null;
    return last.kilowattHours / hours;
  }

  @override
  List<Object?> get props => [
        dashboardId,
        ownerId,
        propertyId,
        deviceIds,
        planTier,
        totalConsumptionKWh,
        costProjectionAmount,
        costProjectionCurrency,
        lastUpdatedAt,
        timeSeries,
        circuitSummaries,
      ];
}
