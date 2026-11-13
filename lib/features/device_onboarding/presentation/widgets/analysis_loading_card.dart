import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AnalysisLoadingCard extends StatelessWidget {
  const AnalysisLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Analizando con IA...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gemini está calculando los umbrales\nóptimos para tu dispositivo',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.grayText,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...List.generate(3, (i) => _buildShimmerRow(i)),
        ],
      ),
    );
  }

  Widget _buildShimmerRow(int index) {
    final widths = [180.0, 240.0, 120.0];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        height: 14,
        width: widths[index % widths.length],
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    );
  }
}
