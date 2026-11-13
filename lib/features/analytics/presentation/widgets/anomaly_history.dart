import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AnomalyHistory extends StatelessWidget {
  const AnomalyHistory({super.key});

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
            'Historial de Anomalías',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 16),
          _AnomalyItem(
            icon: Icons.warning_amber_rounded,
            iconBg: const Color(0xFFFFDAD6),
            iconColor: AppColors.errorRed,
            title: 'Voltage Spike',
            subtitle: '12 Jun \u2022 14:30 - Circuito Principal',
          ),
          const Divider(color: AppColors.lightGray, height: 1),
          _AnomalyItem(
            icon: Icons.sensors_off,
            iconBg: const Color(0xFFDDE3EC),
            iconColor: AppColors.grayText,
            title: 'Connection Lost',
            subtitle: '08 Jun \u2022 02:15 - Hub IoT',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _AnomalyItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool showDivider;

  const _AnomalyItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: showDivider ? 13 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                    letterSpacing: 0.14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: AppColors.grayText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
