import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_top_bar.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const ProfilePage({super.key, this.onMenuTap});

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
                const Icon(Icons.person_outline,
                    size: 64, color: AppColors.lightGray),
                const SizedBox(height: 16),
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkNavy,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tu perfil y configuración.',
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
