import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PeriodTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const PeriodTabs({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const _labels = ['Semana', 'Mes', 'Año'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: List.generate(_labels.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              width: 111.33,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.darkNavy : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                boxShadow: isSelected
                    ? const [BoxShadow(color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1))]
                    : null,
              ),
              child: Text(
                _labels[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.grayText,
                  letterSpacing: 0.14,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
