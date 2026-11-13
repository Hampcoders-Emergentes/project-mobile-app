import 'package:equatable/equatable.dart';
import 'alert_log.dart';
import 'consumption_report.dart';

enum ActivityType { alert, report, service }

/// Ítem del feed "Actividad Reciente".
///
/// El backend no expone un feed unificado: se construye localmente
/// combinando alert-log, consumption-report y (a futuro) service requests.
class ActivityItem extends Equatable {
  final String id;
  final ActivityType type;
  final String title;
  final String subtitle;
  final DateTime timestamp;

  const ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });

  factory ActivityItem.fromAlert(AlertLogEntry entry) {
    final circuit =
        entry.circuitId.isNotEmpty ? ' en circuito ${entry.circuitId}' : '';
    return ActivityItem(
      id: 'alert-${entry.entryId}',
      type: ActivityType.alert,
      title: entry.isResolved ? 'Alerta resuelta' : 'Alerta detectada',
      subtitle: '${entry.alertType}$circuit',
      timestamp: entry.triggeredAt ?? DateTime.now().toUtc(),
    );
  }

  factory ActivityItem.fromReport(ConsumptionReport report) {
    return ActivityItem(
      id: 'report-${report.reportId}',
      type: ActivityType.report,
      title: 'Reporte de consumo generado',
      subtitle: _periodLabel(report),
      timestamp: report.generatedAt ?? DateTime.now().toUtc(),
    );
  }

  static String _periodLabel(ConsumptionReport report) {
    if (report.periodStart == null || report.periodEnd == null) {
      return 'Resumen de consumo eléctrico';
    }
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    final start = report.periodStart!;
    return 'Resumen de ${months[start.month - 1]} ${start.year}';
  }

  @override
  List<Object> get props => [id, type, title, subtitle, timestamp];
}
