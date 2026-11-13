import 'package:flutter/material.dart';
import 'package:mobile_app_electrolink/core/theme/app_theme.dart';

class ResumenFacturaPage extends StatelessWidget {
  const ResumenFacturaPage({super.key});

  static const _green = Color(0xFF006C49);

  void _onConfirm(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solicitud confirmada.')),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepHeader(),
              const SizedBox(height: 8),
              const Text(
                'Resumen y Factura',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Revisa los detalles de tu solicitud de servicio técnico '
                'antes de confirmar.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grayText,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              _buildServiceDetailsCard(),
              const SizedBox(height: 20),
              _buildIotStatusCard(),
              const SizedBox(height: 20),
              _buildBreakdownCard(),
              const SizedBox(height: 20),
              _buildWarrantyBanner(),
              const SizedBox(height: 24),
              _buildConfirmButton(context),
              const SizedBox(height: 14),
              _buildBackButton(context),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepHeader() {
    return const Row(
      children: [
        Icon(Icons.description_outlined, size: 16, color: AppColors.grayText),
        SizedBox(width: 6),
        Text(
          'PASO 3 DE 3',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.grayText,
            letterSpacing: 1.0,
          ),
        ),
      ],
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

  Widget _buildCardTitle(IconData icon, String title, {Color? iconColor, Widget? trailing}) {
    return Row(
      children: [
        Icon(icon, size: 22, color: iconColor ?? AppColors.darkText),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.grayText,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildServiceDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(Icons.info_outline, 'Detalles del Servicio'),
          const SizedBox(height: 20),
          _buildFieldLabel('NOMBRE DE SOLICITUD'),
          const SizedBox(height: 6),
          const Text(
            'Mantenimiento Preventivo',
            style: TextStyle(fontSize: 17, color: AppColors.darkText),
          ),
          const SizedBox(height: 18),
          _buildFieldLabel('CATEGORÍA'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE9EBEE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, size: 15, color: AppColors.darkText),
                SizedBox(width: 4),
                Text(
                  'Alta Tensión',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: AppColors.borderLight.withValues(alpha: 0.5)),
          const SizedBox(height: 18),
          _buildFieldLabel('PROPIEDAD / UBICACIÓN'),
          const SizedBox(height: 8),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined, size: 20, color: AppColors.grayText),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Planta Industrial Norte - Subestación A',
                  style: TextStyle(
                    fontSize: 17,
                    color: AppColors.darkText,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIotStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(
            Icons.sensors,
            'Estado IoT Actual',
            iconColor: _green,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE9EBEE),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: _green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'En Vivo',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Lecturas capturadas de los sensores de la Subestación A para '
            'proveer contexto al equipo técnico.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grayText,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  label: 'Voltaje L1-L2',
                  value: '13.2',
                  footerIcon: Icons.trending_up,
                  footerText: 'kV (Nominal)',
                  footerColor: _green,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildStatTile(
                  label: 'Corriente Promedio',
                  value: '42.5',
                  footerIcon: Icons.drag_handle,
                  footerText: 'Amperios',
                  footerColor: AppColors.grayText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile({
    required String label,
    required String value,
    required IconData footerIcon,
    required String footerText,
    required Color footerColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(footerIcon, size: 15, color: footerColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  footerText,
                  style: TextStyle(fontSize: 13, color: footerColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard() {
    return Container(
      width: double.infinity,
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: _buildCardTitle(
                Icons.receipt_long_outlined, 'Desglose Estimado'),
          ),
          Container(height: 1, color: AppColors.borderLight.withValues(alpha: 0.5)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildBreakdownRow(
                  title: 'Mano de Obra Especializada',
                  subtitle: 'Duración est.: 4 horas',
                  amount: r'$480.00',
                ),
                const SizedBox(height: 16),
                _buildBreakdownRow(
                  title: 'Componentes Previstos',
                  subtitle: 'Kit de sellos, Aceite dieléctrico',
                  amount: r'$720.00',
                ),
                const SizedBox(height: 20),
                Container(
                    height: 1,
                    color: AppColors.borderLight.withValues(alpha: 0.5)),
                const SizedBox(height: 20),
                _buildTotalsRow('Subtotal', r'$1,200.00'),
                const SizedBox(height: 12),
                _buildTotalsRow('Impuestos (IVA 16%)', r'$192.00'),
                const SizedBox(height: 20),
                Container(height: 2, color: AppColors.darkText),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      r'$1,392.00',
                      style: TextStyle(
                        fontSize: 28,
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

  Widget _buildBreakdownRow({
    required String title,
    required String subtitle,
    required String amount,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: AppColors.grayText),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalsRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15, color: AppColors.grayText),
        ),
        Text(
          amount,
          style: const TextStyle(fontSize: 15, color: AppColors.darkText),
        ),
      ],
    );
  }

  Widget _buildWarrantyBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EBEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.gpp_good_outlined, size: 22, color: _green),
          SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.darkText,
                  height: 1.45,
                ),
                children: [
                  TextSpan(
                    text: 'Garantía de Servicio: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '90 días aplicable a mano de obra y componentes '
                        'reemplazados bajo condiciones normales de operación.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _onConfirm(context),
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
            Text(
              'CONFIRMAR SOLICITUD',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.check_circle_outline, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () => Navigator.of(context).maybePop(),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkText,
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.borderLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back, size: 18),
            SizedBox(width: 8),
            Text(
              'ATRÁS',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
