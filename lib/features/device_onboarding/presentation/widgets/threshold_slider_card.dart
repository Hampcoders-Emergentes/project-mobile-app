import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ThresholdSliderCard extends StatelessWidget {
  final String label;
  final String unit;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String Function(double)? formatValue;
  final ValueChanged<double> onChanged;

  const ThresholdSliderCard({
    super.key,
    required this.label,
    required this.unit,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    this.formatValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = formatValue?.call(value) ?? value.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                ),
              ),
              Text(
                '$displayValue $unit',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.darkNavy,
              inactiveTrackColor: AppColors.darkNavy.withAlpha(25),
              thumbColor: Colors.white,
              overlayColor: AppColors.darkNavy.withAlpha(20),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                min.toStringAsFixed(0),
                style: const TextStyle(fontSize: 11, color: AppColors.grayText),
              ),
              Text(
                max.toStringAsFixed(0),
                style: const TextStyle(fontSize: 11, color: AppColors.grayText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
