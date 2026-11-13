import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AppTopBar extends StatelessWidget {
  final bool showBack;
  final VoidCallback? onMenuTap;

  const AppTopBar({super.key, this.showBack = false, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.appBarBg,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: showBack
                ? (onMenuTap ?? () => Navigator.of(context).maybePop())
                : onMenuTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                showBack ? Icons.arrow_back : Icons.menu,
                size: 18,
                color: AppColors.darkNavy,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'ElectroLink',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavy,
              letterSpacing: -0.6,
            ),
          ),
          const Spacer(),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.lightGray,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none,
                size: 16, color: AppColors.darkNavy),
          ),
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.profileBg,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const Icon(Icons.person, size: 20, color: AppColors.darkNavy),
          ),
        ],
      ),
    );
  }
}
