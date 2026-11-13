
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItemData(Icons.home, 'Inicio'),
    _NavItemData(Icons.build_outlined, 'Servicios'),
    _NavItemData(Icons.sensors, 'IoT'),
    _NavItemData(Icons.person_outline, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, -4),
          ),
        ],
      ),
      // Reducido el padding horizontal de 16 a 8 para ganar espacio
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isActive = index == currentIndex;

            // Envolvemos cada botón en un Expanded para que distribuyan el espacio equitativamente
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  // Reducido el padding horizontal interno de 12 a 4 para evitar desbordamientos
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  decoration: isActive
                      ? BoxDecoration(
                    color: AppColors.accentYellow,
                    borderRadius: BorderRadius.circular(9999),
                  )
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 18,
                        color: isActive ? AppColors.darkNavy : AppColors.grayText,
                      ),
                      const SizedBox(height: 4),
                      Flexible( // Flexible evita que el texto rompa el diseño si es muy largo
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 11, // Reducido ligeramente de 12 a 11 para asegurar espacio
                              fontWeight: FontWeight.w500,
                              color: isActive ? AppColors.darkNavy : AppColors.grayText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;

  const _NavItemData(this.icon, this.label);
}