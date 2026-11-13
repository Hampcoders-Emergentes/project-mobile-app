import 'package:flutter/material.dart';
import 'package:mobile_app_electrolink/core/theme/app_theme.dart';
import 'package:mobile_app_electrolink/core/widgets/app_top_bar.dart';

class SubscriptionOverviewPage extends StatelessWidget {
  const SubscriptionOverviewPage({super.key});

  static const _mintGreen = Color(0xFF34D399);
  static const _green = Color(0xFF006C49);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(showBack: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'CURRENT PLAN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grayText,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Suscripción: Enterprise\nPremium',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildActivePill(),
                    const SizedBox(height: 24),
                    _buildDevicesCard(),
                    const SizedBox(height: 20),
                    _buildPaymentsCard(),
                    const SizedBox(height: 20),
                    _buildBillingDetailsCard(),
                    const SizedBox(height: 28),
                    const Text(
                      'Historial de Pagos',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPaymentHistoryTable(),
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

  Widget _buildActivePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: _mintGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'ACTIVA',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
              letterSpacing: 0.8,
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

  Widget _buildDevicesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'DISPOSITIVOS IOT ACTIVOS EN RED',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grayText,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E6F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.sensors,
                    size: 24, color: Color(0xFF3E4784)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '12',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                  letterSpacing: -1.0,
                ),
              ),
              Text(
                ' / 12',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grayText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: const LinearProgressIndicator(
              value: 1.0,
              minHeight: 8,
              backgroundColor: Color(0xFFE9EBEE),
              valueColor: AlwaysStoppedAnimation(_mintGreen),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle_outline, size: 18, color: _green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Capacidad máxima alcanzada. Para agregar más nodos, '
                  'actualice su plan.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grayText,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.credit_card, size: 24, color: Colors.black),
          ),
          const SizedBox(height: 20),
          const Text(
            'Gestión de Pagos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Administre métodos de pago, descargue facturas completas y '
            'actualice información de facturación a través de nuestro '
            'portal seguro.',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFFB9BDC7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                // TODO: abrir el portal del cliente (checkout/portal del backend).
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ABRIR PORTAL DEL CLIENTE',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.open_in_new, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DETALLES DE FACTURACIÓN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.grayText,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: AppColors.borderLight.withValues(alpha: 0.5)),
          const SizedBox(height: 20),
          const Text(
            'Costo por Nodo',
            style: TextStyle(fontSize: 15, color: AppColors.grayText),
          ),
          const SizedBox(height: 4),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                r'$15.00',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              Text(
                ' / mes',
                style: TextStyle(fontSize: 15, color: AppColors.grayText),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Facturación Mensual Actual',
            style: TextStyle(fontSize: 15, color: AppColors.grayText),
          ),
          const SizedBox(height: 4),
          const Text(
            r'$180.00',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Próxima Renovación',
            style: TextStyle(fontSize: 15, color: AppColors.grayText),
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 18, color: AppColors.darkText),
              SizedBox(width: 8),
              Text(
                '1 de Agosto, 2026',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryTable() {
    return Container(
      width: double.infinity,
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: const Color(0xFFEFF1F5),
            child: const Row(
              children: [
                Expanded(flex: 3, child: _TableHeaderText('ID DE\nFACTURA')),
                Expanded(flex: 2, child: _TableHeaderText('FECHA')),
                Expanded(flex: 2, child: _TableHeaderText('MONTO')),
                Expanded(flex: 3, child: _TableHeaderText('ESTADO')),
              ],
            ),
          ),
          _buildPaymentRow('INV-2026-07A', '1 Jul,\n2026', r'$180.00'),
          Container(height: 1, color: AppColors.borderLight.withValues(alpha: 0.4)),
          _buildPaymentRow('INV-2026-06A', '1 Jun,\n2026', r'$180.00'),
          Container(height: 1, color: AppColors.borderLight.withValues(alpha: 0.4)),
          _buildPaymentRow('INV-2026-05A', '1 May,\n2026', r'$180.00'),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String invoiceId, String date, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              invoiceId,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.darkText,
                height: 1.35,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grayText,
                height: 1.35,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              amount,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.darkText,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF86F0C0),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 13, color: Color(0xFF065F46)),
                    SizedBox(width: 4),
                    Text(
                      'ÉXITO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF065F46),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeaderText extends StatelessWidget {
  final String text;

  const _TableHeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.grayText,
        letterSpacing: 0.6,
        height: 1.3,
      ),
    );
  }
}
