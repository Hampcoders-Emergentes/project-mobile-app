import 'package:flutter/material.dart';
import 'package:mobile_app_electrolink/core/theme/app_theme.dart';
import 'package:mobile_app_electrolink/features/subscription/presentation/pages/subscription_overview_page.dart';

class SubscriptionPlanPage extends StatefulWidget {
  const SubscriptionPlanPage({super.key});

  @override
  State<SubscriptionPlanPage> createState() => _SubscriptionPlanPageState();
}

class _SubscriptionPlanPageState extends State<SubscriptionPlanPage> {
  static const _plans = [
    (
      name: 'Enterprise Basic',
      description:
          'Monitoreo esencial y reportes mensuales para instalaciones pequeñas.',
    ),
    (
      name: 'Enterprise Premium',
      description:
          'Telemetría en tiempo real, API de acceso total y soporte prioritario.',
    ),
  ];

  static const _costPerDevice = 15.0;

  int _selectedPlan = 1;
  int _deviceCount = 1;

  double get _monthlyTotal => _deviceCount * _costPerDevice;

  String get _planShortName => _selectedPlan == 1 ? 'Premium' : 'Basic';

  void _proceedToPayment() {
    // TODO: integrar el checkout real de Stripe (backend /subscriptions/checkout).
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SubscriptionOverviewPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildSectionTitle(
                        Icons.layers_outlined, 'PLANES DISPONIBLES'),
                    const SizedBox(height: 16),
                    _buildPlanCard(0),
                    const SizedBox(height: 16),
                    _buildPlanCard(1),
                    const SizedBox(height: 28),
                    Container(
                      height: 1,
                      color: AppColors.borderLight.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 28),
                    const Row(
                      children: [
                        Icon(Icons.sensors, size: 20, color: AppColors.darkText),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Recuento Inicial de Dispositivos IoT',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDeviceStepper(),
                    const SizedBox(height: 16),
                    const Text(
                      'Especifica el número de nodos de telemetría que '
                      'integrarás en la red. Podrás ajustar esta cantidad '
                      'posteriormente desde el panel de administración.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grayText,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              _buildQuoteSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight.withValues(alpha: 0.5)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, size: 20, color: AppColors.grayText),
                SizedBox(width: 6),
                Text(
                  'VOLVER',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grayText,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Suscripción Empresarial',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Configura tu plan y selecciona la cantidad inicial de '
            'dispositivos para comenzar tu despliegue.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grayText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.darkText),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(int index) {
    final plan = _plans[index];
    final isSelected = _selectedPlan == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF2F3F5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.black : AppColors.borderLight,
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan.name,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
                if (isSelected)
                  const CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.check, size: 16, color: Colors.white),
                  )
                else
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderLight, width: 2),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              plan.description,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.grayText,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceStepper() {
    return Container(
      height: 60,
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          _buildStepperButton(
            icon: Icons.remove,
            onTap: () {
              if (_deviceCount > 1) setState(() => _deviceCount--);
            },
          ),
          Container(width: 1, color: AppColors.borderLight),
          Expanded(
            child: Container(
              color: const Color(0xFFF7F8FA),
              alignment: Alignment.center,
              child: Text(
                '$_deviceCount',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ),
          ),
          Container(width: 1, color: AppColors.borderLight),
          _buildStepperButton(
            icon: Icons.add,
            onTap: () => setState(() => _deviceCount++),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Icon(icon, size: 22, color: AppColors.darkText),
      ),
    );
  }

  Widget _buildQuoteSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: const Color(0xFFE9EAEC),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildQuoteRow(
                  'Costo por Dispositivo',
                  '\$${_costPerDevice.toStringAsFixed(2)}/mes',
                ),
                const SizedBox(height: 12),
                _buildQuoteRow('Plan Base ($_planShortName)', r'$0.00/mes'),
                const SizedBox(height: 18),
                Container(
                  height: 1,
                  color: AppColors.borderLight.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Total\nMensual',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      '\$${_monthlyTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkText,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _proceedToPayment,
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
                  Icon(Icons.lock_outline, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Proceder al Pago con Stripe',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'TRANSACCIÓN SEGURA Y CIFRADA',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.grayText,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildQuoteRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 17, color: AppColors.grayText),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
      ],
    );
  }
}
