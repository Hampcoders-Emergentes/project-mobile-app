import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/consumption_dashboard.dart';
import '../utils/format.dart';

const _okGreen = Color(0xFF006C49);

class ConsumptionCard extends StatelessWidget {
  final ConsumptionDashboard? consumption;
  final VoidCallback? onTap;

  const ConsumptionCard({super.key, required this.consumption, this.onTap});

  @override
  Widget build(BuildContext context) {
    final data = consumption;
    final weekChange = data?.percentChange(const Duration(days: 7));
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONSUMO TOTAL',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grayText,
                        letterSpacing: 0.7,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Este mes',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grayText,
                      ),
                    ),
                  ],
                ),
                if (data != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.greenBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.greenBorder),
                    ),
                    child: Text(
                      'Costo est.: ${IotFormat.currency(data.costProjectionAmount, data.costProjectionCurrency)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _okGreen,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (data == null)
              const Text(
                'Sin datos de consumo aún',
                style: TextStyle(fontSize: 14, color: AppColors.grayText),
              )
            else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    IotFormat.number(data.totalConsumptionKWh),
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                      letterSpacing: -0.9,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'kWh',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.grayText,
                    ),
                  ),
                ],
              ),
              if (weekChange != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      weekChange <= 0 ? Icons.trending_down : Icons.trending_up,
                      size: 16,
                      color: weekChange <= 0 ? _okGreen : AppColors.errorRed,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${IotFormat.percent(weekChange)} vs semana pasada',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: weekChange <= 0 ? _okGreen : AppColors.errorRed,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
