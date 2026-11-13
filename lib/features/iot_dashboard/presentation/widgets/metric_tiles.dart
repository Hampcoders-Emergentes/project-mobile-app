import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/consumption_dashboard.dart';
import '../utils/format.dart';

const _okGreen = Color(0xFF006C49);

/// Fila de indicadores: Voltaje Pico y Dispositivos Activos.
///
/// Reemplaza la tarjeta "Power Factor" del diseño original: el backend no
/// expone potencia activa/aparente, así que ese indicador quedó descopado.
class MetricTilesRow extends StatelessWidget {
  final ConsumptionDashboard? consumption;
  final DateTime now;

  const MetricTilesRow({super.key, required this.consumption, required this.now});

  @override
  Widget build(BuildContext context) {
    final data = consumption;
    final online = data?.onlineDevices(now) ?? 0;
    final total = data?.totalDevices ?? 0;
    final peak = data?.maxPeakVoltage ?? 0;
    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            label: 'VOLTAJE PICO',
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  peak > 0 ? IotFormat.number(peak, decimals: 0) : '--',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'V',
                  style: TextStyle(fontSize: 16, color: AppColors.grayText),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricTile(
            label: 'DISPOSITIVOS ACTIVOS',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$online',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    Text(
                      '/$total',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grayText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: LinearProgressIndicator(
                    value: total > 0 ? online / total : 0,
                    minHeight: 6,
                    backgroundColor: AppColors.lightGray,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(_okGreen),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final Widget child;

  const _MetricTile({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 104),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.grayText,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
