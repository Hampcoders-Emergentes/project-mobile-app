import 'package:flutter/material.dart';
import 'package:mobile_app_electrolink/core/theme/app_theme.dart';
import 'package:mobile_app_electrolink/features/company/presentation/screens/resumen_factura_page.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  void _goToDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ResumenFacturaPage()),
    );
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.6)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildCheckBadge(),
                  const SizedBox(height: 28),
                  const Text(
                    '¡Solicitud Recibida!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Su solicitud de servicio ha sido confirmada y '
                    'nuestro equipo está en camino.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: AppColors.grayText,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildDetailsCard(),
                  const SizedBox(height: 20),
                  _buildEtaTile(),
                  const SizedBox(height: 28),
                  _buildDetailButton(context),
                  const SizedBox(height: 14),
                  _buildHomeButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckBadge() {
    return Container(
      width: 110,
      height: 110,
      decoration: const BoxDecoration(
        color: Color(0xFF66F2B8),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFF0B6B4E),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 32, color: Colors.white),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detalles de la Solicitud',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: AppColors.borderLight.withValues(alpha: 0.6)),
          const SizedBox(height: 20),
          _buildDetailField('ID de Solicitud', '#EL-8492-FX'),
          const SizedBox(height: 20),
          _buildDetailField('Tipo de Servicio', 'Revisión de Tablero Principal'),
          const SizedBox(height: 20),
          _buildDetailField(
            'Dirección de la Propiedad',
            'Av. de la Industria 1450, Planta Baja, Sector 4',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: AppColors.grayText),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildEtaTile() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, size: 26, color: Color(0xFF006C49)),
          const SizedBox(width: 16),
          Expanded(
            child: Text.rich(
              const TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                  height: 1.35,
                ),
                children: [
                  TextSpan(text: 'Técnico llegará en aproximadamente '),
                  TextSpan(
                    text: '45 min',
                    style: TextStyle(color: Color(0xFF006C49)),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _goToDetail(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 20),
            SizedBox(width: 10),
            Text(
              'Ver Detalle',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () => _goHome(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkText,
          side: const BorderSide(color: AppColors.borderLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_outlined, size: 20),
            SizedBox(width: 10),
            Text(
              'Volver a Inicio',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
