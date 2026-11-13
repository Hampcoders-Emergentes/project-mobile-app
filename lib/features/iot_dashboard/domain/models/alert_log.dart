import 'package:equatable/equatable.dart';

enum AlertSeverity {
  critical,
  warning,
  info;

  static AlertSeverity parse(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'CRITICAL':
      case 'HIGH':
        return AlertSeverity.critical;
      case 'WARNING':
      case 'MEDIUM':
        return AlertSeverity.warning;
      default:
        return AlertSeverity.info;
    }
  }
}

class AlertLogEntry extends Equatable {
  final String entryId;
  final String sourceEventId;
  final String sourceBC;
  final String alertType;
  final AlertSeverity severity;
  final String status;
  final String circuitId;
  final String? serviceRequestId;
  final DateTime? triggeredAt;
  final DateTime? acknowledgedAt;
  final DateTime? resolvedAt;

  const AlertLogEntry({
    required this.entryId,
    required this.sourceEventId,
    required this.sourceBC,
    required this.alertType,
    required this.severity,
    required this.status,
    required this.circuitId,
    this.serviceRequestId,
    this.triggeredAt,
    this.acknowledgedAt,
    this.resolvedAt,
  });

  factory AlertLogEntry.fromJson(Map<String, dynamic> json) {
    return AlertLogEntry(
      entryId: json['entryId'] as String? ?? '',
      sourceEventId: json['sourceEventId'] as String? ?? '',
      sourceBC: json['sourceBC'] as String? ?? '',
      alertType: json['alertType'] as String? ?? '',
      severity: AlertSeverity.parse(json['severity'] as String?),
      status: json['status'] as String? ?? '',
      circuitId: json['circuitId'] as String? ?? '',
      serviceRequestId: json['serviceRequestId'] as String?,
      triggeredAt:
          DateTime.tryParse(json['triggeredAt'] as String? ?? '')?.toUtc(),
      acknowledgedAt:
          DateTime.tryParse(json['acknowledgedAt'] as String? ?? '')?.toUtc(),
      resolvedAt:
          DateTime.tryParse(json['resolvedAt'] as String? ?? '')?.toUtc(),
    );
  }

  bool get isResolved =>
      resolvedAt != null || status.toUpperCase() == 'RESOLVED';

  bool get isAcknowledged =>
      acknowledgedAt != null || status.toUpperCase() == 'ACKNOWLEDGED';

  @override
  List<Object?> get props => [
        entryId,
        sourceEventId,
        sourceBC,
        alertType,
        severity,
        status,
        circuitId,
        serviceRequestId,
        triggeredAt,
        acknowledgedAt,
        resolvedAt,
      ];
}

class AlertLog extends Equatable {
  final String logId;
  final String ownerId;
  final List<AlertLogEntry> entries;

  const AlertLog({
    required this.logId,
    required this.ownerId,
    required this.entries,
  });

  factory AlertLog.fromJson(Map<String, dynamic> json) {
    final entries = (json['entries'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(AlertLogEntry.fromJson)
        .toList()
      ..sort((a, b) => (b.triggeredAt ?? DateTime(0))
          .compareTo(a.triggeredAt ?? DateTime(0)));
    return AlertLog(
      logId: json['logId'] as String? ?? '',
      ownerId: json['ownerId'] as String? ?? '',
      entries: entries,
    );
  }

  static const empty = AlertLog(logId: '', ownerId: '', entries: []);

  /// Alerta más reciente sin resolver, priorizando severidad crítica.
  AlertLogEntry? get activeAlert {
    final unresolved = entries.where((e) => !e.isResolved).toList();
    if (unresolved.isEmpty) return null;
    for (final entry in unresolved) {
      if (entry.severity == AlertSeverity.critical) return entry;
    }
    return unresolved.first;
  }

  /// Circuitos con alguna alerta sin resolver: la tabla los marca como Falla.
  Set<String> get faultedCircuitIds => entries
      .where((e) => !e.isResolved && e.circuitId.isNotEmpty)
      .map((e) => e.circuitId)
      .toSet();

  @override
  List<Object> get props => [logId, ownerId, entries];
}
