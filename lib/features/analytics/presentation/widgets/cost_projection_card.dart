import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CostProjectionCard extends StatelessWidget {
  const CostProjectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.darkNavy,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.brandLogoBg),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F182442),
            blurRadius: 30,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Proyección este mes',
                style: TextStyle(fontSize: 16, color: Color(0xFF98A4C9)),
              ),
              const Icon(Icons.trending_up, size: 12, color: Color(0xFF98A4C9)),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'S/ 145.00',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.96,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.arrow_upward, size: 9.33, color: AppColors.green),
              const SizedBox(width: 4),
              const Text(
                '12% vs mes anterior',
                style: TextStyle(fontSize: 11, color: AppColors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
