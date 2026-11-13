import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CircuitComparison extends StatelessWidget {
  const CircuitComparison({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comparativa por Circuito',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 24),
          _CircuitBar(
            icon: Icons.lightbulb_outline,
            label: 'Iluminación',
            percentage: 45,
            barColor: AppColors.darkNavy,
          ),
          const SizedBox(height: 16),
          _CircuitBar(
            icon: Icons.ac_unit,
            label: 'Aire Acondicionado',
            percentage: 35,
            barColor: const Color(0xFFAACADA),
          ),
          const SizedBox(height: 16),
          _CircuitBar(
            icon: Icons.devices_outlined,
            label: 'Otros',
            percentage: 20,
            barColor: AppColors.borderLight,
          ),
        ],
      ),
    );
  }
}

class _CircuitBar extends StatelessWidget {
  final IconData icon;
  final String label;
  final int percentage;
  final Color barColor;

  const _CircuitBar({
    required this.icon,
    required this.label,
    required this.percentage,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 13, color: AppColors.darkText),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.grayText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(9999),
          child: SizedBox(
            height: 8,
            width: double.infinity,
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppColors.lightGray,
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
        ),
      ],
    );
  }
}
