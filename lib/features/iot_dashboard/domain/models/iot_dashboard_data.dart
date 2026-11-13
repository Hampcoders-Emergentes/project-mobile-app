import 'package:equatable/equatable.dart';
import 'activity_item.dart';
import 'alert_log.dart';
import 'consumption_dashboard.dart';
import 'consumption_report.dart';
import 'owner_context.dart';

/// Agregado que alimenta el Home y el Monitoreo IoT para cualquier owner.
class IotDashboardData extends Equatable {
  final OwnerContext owner;
  final ConsumptionDashboard? consumption;
  final AlertLog alerts;
  final List<ConsumptionReport> reports;
  final DateTime fetchedAt;

  const IotDashboardData({
    required this.owner,
    required this.consumption,
    required this.alerts,
    required this.reports,
    required this.fetchedAt,
  });

  AlertLogEntry? get activeAlert => alerts.activeAlert;

  /// Feed local: alertas + reportes, más recientes primero.
  /// Pendiente sumar service requests cuando exista endpoint de listado.
  List<ActivityItem> get activity {
    final items = <ActivityItem>[
      ...alerts.entries.map(ActivityItem.fromAlert),
      ...reports.where((r) => r.isGenerated).map(ActivityItem.fromReport),
    ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items.take(6).toList();
  }

  IotDashboardData copyWith({
    ConsumptionDashboard? consumption,
    AlertLog? alerts,
    List<ConsumptionReport>? reports,
    DateTime? fetchedAt,
  }) {
    return IotDashboardData(
      owner: owner,
      consumption: consumption ?? this.consumption,
      alerts: alerts ?? this.alerts,
      reports: reports ?? this.reports,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }

  @override
  List<Object?> get props => [owner, consumption, alerts, reports, fetchedAt];
}
