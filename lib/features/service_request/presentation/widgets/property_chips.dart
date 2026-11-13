import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PropertyChips extends StatelessWidget {
  final String selectedProperty;
  final ValueChanged<String> onSelected;

  const PropertyChips({
    super.key,
    required this.selectedProperty,
    required this.onSelected,
  });

  static const properties = ['Casa Principal', 'Oficina', 'Nueva'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Propiedad Seleccionada',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
            letterSpacing: 0.14,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: properties.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final property = properties[index];
              final isSelected = property == selectedProperty;
              final isNew = property == 'Nueva';

              if (isNew) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: const Color(0xFF75777E),
                      width: 1.5,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, size: 9.75, color: AppColors.darkNavy),
                      const SizedBox(width: 8),
                      const Text(
                        'Nueva',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkNavy,
                          letterSpacing: 0.14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return GestureDetector(
                onTap: () => onSelected(property),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 11),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accentYellow : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(9999),
                    border: isSelected
                        ? Border.all(color: Colors.transparent)
                        : Border.all(color: AppColors.borderLight),
                    boxShadow: isSelected
                        ? const [BoxShadow(color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1))]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? Icons.home : Icons.business_outlined,
                        size: isSelected ? 12.67 : 13.13,
                        color: isSelected ? AppColors.planBadgeText : AppColors.grayText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        property,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.planBadgeText : AppColors.grayText,
                          letterSpacing: 0.14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
