import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_top_bar.dart';

class PropertiesPage extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const PropertiesPage({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTopBar(onMenuTap: onMenuTap),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.business_outlined,
                    size: 64, color: AppColors.lightGray),
                const SizedBox(height: 16),
                const Text(
                  'Mis Propiedades',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkNavy,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gestiona tus propiedades registradas.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grayText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
