import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PropertyDetailCard extends StatelessWidget {
  const PropertyDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x082E3A59),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.business_outlined,
                    size: 18, color: AppColors.darkNavy),
                const SizedBox(width: 8),
                Text(
                  'Detalles de la Propiedad',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 17),
            _DetailRow(label: 'Sede', value: 'Sede San Isidro'),
            const SizedBox(height: 24),
            _DetailRow(
                label: 'Tipo de Servicio',
                value: 'Mantenimiento Correctivo IoT'),
            const SizedBox(height: 24),
            _buildIoTDeviceCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildIoTDeviceCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.brandLogoBg),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.darkNavy,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.memory,
                        size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text(
                      'Dispositivo IoT\nDetectado',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.28,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 9, right: 22.61, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: AppColors.yellowBg,
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: AppColors.yellowBorder),
                  ),
                  child: const Text(
                    'ID:EL-99',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accentYellow,
                      letterSpacing: 0.12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.profileBg,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(7),
                bottomRight: Radius.circular(7),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MetricBox(
                    label: 'VOLTAJE',
                    value: '238 V',
                    valueColor: const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _MetricBox(
                    label: 'CORRIENTE',
                    value: '18.5 A',
                    valueColor: const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.grayText,
            letterSpacing: 0.12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.darkText,
          ),
        ),
      ],
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _MetricBox({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.grayText,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor,
              letterSpacing: 0.28,
            ),
          ),
        ],
      ),
    );
  }
}
