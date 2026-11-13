import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_electrolink/core/theme/app_theme.dart';

class ServiceTrackingPage extends StatelessWidget {
  const ServiceTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    const Text(
                      'Suscripción: Enterprise\nPremium',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                        height: 1.2,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildPendingBanner(),
                    const SizedBox(height: 24),
                    _buildTrackerCard(),
                    const SizedBox(height: 20),
                    _buildDeadlineCard(),
                    const SizedBox(height: 20),
                    _buildNextStepsCard(),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        'Su suscripción se activará automáticamente tras la\ninstalación',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.grayText,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.appBarBg,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back, size: 22, color: AppColors.darkText),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'ElectroLink',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ),
          const Icon(Icons.notifications_none, size: 24, color: AppColors.darkText),
        ],
      ),
    );
  }

  Widget _buildPendingBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8B054),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_outlined, size: 28, color: Color(0xFF6E4A0A)),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Suscripción Pendiente de Instalación',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6E4A0A),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Service Order Tracker',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grayText,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAED),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Programado',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Instalación de Hardware IoT',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.profileBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: const Icon(Icons.person, size: 30, color: AppColors.darkNavy),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Técnico\nAsignado',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.grayText,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'David Chen',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                    ],
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Estimated\nArrival',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grayText,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '09:00 AM',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: _cardDecoration(),
      child: const Column(
        children: [
          Icon(Icons.pending_actions, size: 52, color: Color(0xFFB6BAC2)),
          SizedBox(height: 16),
          Text(
            'Límite para instalación',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.grayText,
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '24 de Julio, 2026',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Color(0xFF006C49),
                child: Icon(Icons.check, size: 16, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text(
                'Próximos Pasos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Text(
            'Por favor asegure acceso al panel principal de energía en la '
            'fecha programada. El equipo de instalación requiere '
            'aproximadamente 2 horas para completar el despliegue del '
            'hardware IoT.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grayText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.6)),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
