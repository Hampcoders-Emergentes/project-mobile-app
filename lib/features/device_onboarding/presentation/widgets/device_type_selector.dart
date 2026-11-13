import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DeviceTypeSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelected;

  static const List<_DeviceTypeOption> _types = [
    _DeviceTypeOption('HVAC', Icons.ac_unit),
    _DeviceTypeOption('WaterHeater', Icons.water_drop),
    _DeviceTypeOption('Refrigerator', Icons.kitchen),
    _DeviceTypeOption('SolarInverter', Icons.solar_power),
    _DeviceTypeOption('EVCharger', Icons.electric_car),
    _DeviceTypeOption('Other', Icons.miscellaneous_services),
  ];

  const DeviceTypeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _types.map((type) {
        final isSelected = selected == type.value;
        return GestureDetector(
          onTap: () => onSelected(type.value),
          child: Container(
            width: (MediaQuery.of(context).size.width - 68) / 3,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.darkNavy : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.darkNavy : const Color(0xFFE5E7EB),
              ),
            ),
            child: Column(
              children: [
                Icon(type.icon,
                    size: 28,
                    color: isSelected ? Colors.white : AppColors.grayText),
                const SizedBox(height: 8),
                Text(
                  type.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.darkText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DeviceTypeOption {
  final String value;
  final IconData icon;

  const _DeviceTypeOption(this.value, this.icon);

  String get label {
    switch (value) {
      case 'HVAC': return 'HVAC';
      case 'WaterHeater': return 'Calentador';
      case 'Refrigerator': return 'Refrigerador';
      case 'SolarInverter': return 'Inversor Solar';
      case 'EVCharger': return 'Cargador EV';
      case 'Other': return 'Otro';
      default: return value;
    }
  }
}
