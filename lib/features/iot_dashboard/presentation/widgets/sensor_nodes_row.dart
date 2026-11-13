import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/consumption_dashboard.dart';

const _onlineGreen = Color(0xFF006C49);
const _offlineGray = Color(0xFF76777D);

/// Chips de nodos con estado Online/Offline derivado de `lastReadingAt`
/// (heurística local: sin lecturas por más de 5 minutos = Offline).
class SensorNodesRow extends StatelessWidget {
  final List<CircuitSummary> circuits;
  final DateTime now;

  const SensorNodesRow({super.key, required this.circuits, required this.now});

  @override
  Widget build(BuildContext context) {
    if (circuits.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: const Text(
          'Aún no hay dispositivos vinculados',
          style: TextStyle(fontSize: 13, color: AppColors.grayText),
        ),
      );
    }
    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: circuits.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final circuit = circuits[index];
          final isOnline = circuit.isOnline(now);
          final dotColor = isOnline ? _onlineGreen : _offlineGray;
          return Container(
            padding: const EdgeInsets.fromLTRB(13, 13, 24, 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isOnline)
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: dotColor.withAlpha(51),
                            shape: BoxShape.circle,
                          ),
                        ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      circuit.circuitId,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      isOnline ? 'En línea' : 'Sin señal',
                      style: TextStyle(fontSize: 12, color: dotColor),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
