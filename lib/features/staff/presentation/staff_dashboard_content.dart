import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/staff_models.dart';
import 'staff_dashboard_controller.dart';
import 'staff_widgets.dart';

class StaffDashboardContent extends StatelessWidget {
  final StaffDashboardState state;
  final Set<String> saving;
  final void Function(StaffStore, StaffEquipment, StaffAlert) onAcknowledge;
  final void Function(StaffEquipment) onOpenEquipment;
  const StaffDashboardContent({
    super.key,
    required this.state,
    required this.saving,
    required this.onAcknowledge,
    required this.onOpenEquipment,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: _content(context),
  );
  List<Widget> _content(BuildContext context) {
    final summary = state.dashboard!,
        alerts = state.alerts!,
        store = state.selected!;
    return [
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(
          'Actualizado ${staffTime(summary.generatedAt)} · hora del dispositivo',
          style: const TextStyle(color: AppColors.grayText),
        ),
      ),
      StaffSection(
        title: 'Alertas activas (${alerts.critical + alerts.nonCritical})',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (alerts.items.isEmpty)
              const StaffPanel(
                child: Text('No hay alertas activas registradas.'),
              ),
            if (alerts.critical + alerts.nonCritical > alerts.items.length)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Mostrando hasta 100 alertas. Los contadores incluyen el total del local.',
                ),
              ),
            ...alerts.items.map((alert) {
              final matches = summary.equipment.where(
                (e) => e.id == alert.equipmentId,
              );
              final equipment = matches.isEmpty ? null : matches.first;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: StaffPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${alert.severity == 'CRITICAL'
                            ? 'CRÍTICA'
                            : alert.severity == 'NON_CRITICAL'
                            ? 'NO CRÍTICA'
                            : 'SEVERIDAD DESCONOCIDA'} · ${alert.statusLabel}',
                        style: TextStyle(
                          color: alert.severity == 'CRITICAL'
                              ? AppColors.errorRed
                              : AppColors.darkNavy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        alert.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        equipment?.name ?? 'Equipo no disponible en el resumen',
                      ),
                      Text(staffTime(alert.createdAt)),
                      if (alert.description?.isNotEmpty == true)
                        Text(alert.description!),
                      if (alert.status == 'OPEN')
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: OutlinedButton(
                            onPressed:
                                equipment == null || saving.contains(alert.id)
                                ? null
                                : () => onAcknowledge(store, equipment, alert),
                            child: Text(
                              saving.contains(alert.id)
                                  ? 'Guardando reconocimiento…'
                                  : 'Reconocer alerta',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      StaffSection(
        title: 'Resumen del local',
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _metric(context, 'Equipos', summary.total, Icons.kitchen_outlined),
            _metric(context, 'Monitorizados', summary.monitored, Icons.sensors),
            _metric(
              context,
              'Sin conexión o datos',
              summary.offline,
              Icons.sensors_off,
            ),
            _metric(context, 'Sin sensor', summary.unmonitored, Icons.link_off),
            _metric(
              context,
              'Alertas críticas',
              alerts.critical,
              Icons.warning_amber,
            ),
            _metric(
              context,
              'Otras alertas',
              alerts.nonCritical,
              Icons.notifications_outlined,
            ),
          ],
        ),
      ),
      StaffSection(
        title: 'Equipos del local',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'El estado de lectura no confirma que un equipo sea apto para limpieza. Abre su detalle para consultar la evaluación.',
            ),
            const SizedBox(height: 12),
            if (summary.equipment.isEmpty)
              const StaffPanel(
                child: Text('Este local todavía no tiene equipos registrados.'),
              ),
            ...summary.equipment.map(
              (equipment) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: StaffPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        equipment.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(equipment.areaName),
                      const SizedBox(height: 8),
                      Text(equipment.stateLabel),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.cleaning_services_outlined),
                        label: const Text('Consultar equipo'),
                        onPressed: () => onOpenEquipment(equipment),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _metric(
    BuildContext context,
    String label,
    int value,
    IconData icon,
  ) => SizedBox(
    width: 144,
    child: StaffPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.darkNavy),
          const SizedBox(height: 12),
          Text(
            '$value',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(label),
        ],
      ),
    ),
  );
}
