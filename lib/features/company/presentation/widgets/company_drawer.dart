// lib/features/company/presentation/widgets/company_drawer.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../analytics/presentation/pages/analytics_page.dart';
import '../../../subscription/presentation/pages/subscription_plan_page.dart';
import '../../../auth/presentation/screens/auth_screen.dart';

class CompanyDrawer extends StatefulWidget {
  final int currentIndex;
  final void Function(int index)? onNavigateToTab;

  const CompanyDrawer({super.key, this.currentIndex = 0, this.onNavigateToTab});

  @override
  State<CompanyDrawer> createState() => _CompanyDrawerState();
}

class _CompanyDrawerState extends State<CompanyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          width: 320,
          decoration: const BoxDecoration(
            color: AppColors.drawerBg,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Column(
            children: [
              _buildHeader(),
              _buildProfileCard(),
              const SizedBox(height: 16),
              Expanded(child: _buildNavLinks()),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.brandLogoBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.bolt, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            'ElectroLink',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavy,
              letterSpacing: -0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.appBarBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: const Icon(Icons.person, size: 28, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Facility Manager',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkNavy,
                    ),
                  ),
                  Text(
                    'ElectroLink Enterprise',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.grayText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.planBadgeBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Premium Account',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.planBadgeText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavLinks() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // SECCIÓN PRINCIPAL
        _NavItem(
          icon: Icons.home_outlined,
          label: 'Inicio',
          isActive: widget.currentIndex == 0,
          onTap: () => _navigateToTab(0),
        ),
        _NavItem(
          icon: Icons.engineering_outlined,
          label: 'Gestión de Servicios',
          isActive: widget.currentIndex == 1,
          onTap: () => _navigateToTab(1),
        ),
        _NavItem(
          icon: Icons.sensors_outlined,
          label: 'Monitoreo IoT',
          isActive: widget.currentIndex == 2,
          onTap: () => _navigateToTab(2),
        ),
        _NavItem(
          icon: Icons.analytics_outlined,
          label: 'Analytics y Consumo',
          isActive: false,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: SafeArea(child: AnalyticsPage(showBack: true)),
                ),
              ),
            );
          },
        ),
        _NavItem(
          icon: Icons.person_outline,
          label: 'Perfil',
          isActive: widget.currentIndex == 3,
          onTap: () => _navigateToTab(3),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Text(
            'ADMINISTRACIÓN',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.grayText,
              letterSpacing: 1.2,
            ),
          ),
        ),

        // SECCIÓN ADMINISTRACIÓN
        _NavItem(
          icon: Icons.credit_card_outlined,
          label: 'Suscripción',
          isActive: false,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SubscriptionPlanPage()),
            );
          },
        ),
      ],
    );
  }

  void _navigateToTab(int index) {
    Navigator.of(context).pop(); // Cierra el Drawer
    widget.onNavigateToTab?.call(index); // Cambia el IndexedStack
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: 16),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthScreen()),
                    (route) => false,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.logout, size: 20, color: AppColors.errorRed),
                  const SizedBox(width: 12),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.errorRed,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          // Si está activo usa un color sutil verde/azul del mockup, si no transparente
          color: isActive ? AppColors.drawerActiveBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? AppColors.drawerActiveText : AppColors.grayText,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? AppColors.drawerActiveText : AppColors.darkNavy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}