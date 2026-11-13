import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/alert_log.dart';
import '../utils/format.dart';

const _alertBg = Color(0xFFFFEDEA);

class AlertBanner extends StatelessWidget {
  final AlertLogEntry alert;
  final VoidCallback? onViewDetails;

  const AlertBanner({super.key, required this.alert, this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    final isCritical = alert.severity == AlertSeverity.critical;
    final circuit =
        alert.circuitId.isNotEmpty ? ' en circuito ${alert.circuitId}' : '';
    final when =
        alert.triggeredAt != null ? ' ${IotFormat.relative(alert.triggeredAt!)}.' : '';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _alertBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.errorRed),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_rounded,
              size: 24, color: AppColors.errorRed),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCritical ? 'Alerta Crítica' : 'Alerta',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.errorRed,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${alert.alertType}$circuit.$when',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.errorRed,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onViewDetails,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF93000A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Ver detalles',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
