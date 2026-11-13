import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_top_bar.dart';

class CompanyPropertiesPage extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const CompanyPropertiesPage({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTopBar(onMenuTap: onMenuTap),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mis Sedes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkNavy,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Gestiona las sedes y oficinas de tu empresa.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grayText,
                  ),
                ),
                const SizedBox(height: 20),
                _buildPropertyCard(
                  name: 'Sede Principal',
                  address: 'Av. Empresarial 456, San Isidro',
                  type: 'Comercial',
                  isActive: true,
                  isPrimary: true,
                  consumption: '12,500 kWh',
                  devices: 2,
                ),
                const SizedBox(height: 12),
                _buildPropertyCard(
                  name: 'Sucursal Surco',
                  address: 'Av. Industrial 789, Surco',
                  type: 'Comercial',
                  isActive: true,
                  isPrimary: false,
                  consumption: '8,300 kWh',
                  devices: 1,
                ),
                const SizedBox(height: 12),
                _buildPropertyCard(
                  name: 'Oficina Callao',
                  address: 'Calle Los Puertos 321, Callao',
                  type: 'Comercial',
                  isActive: false,
                  isPrimary: false,
                  consumption: '0 kWh',
                  devices: 0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyCard({
    required String name,
    required String address,
    required String type,
    required bool isActive,
    required bool isPrimary,
    required String consumption,
    required int devices,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primaryBlue.withValues(alpha: 0.1) : AppColors.lightGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.business,
                  size: 24,
                  color: isActive ? AppColors.primaryBlue : AppColors.grayText,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkNavy,
                          ),
                        ),
                        if (isPrimary) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accentYellow,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Principal',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkNavy,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      address,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grayText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.greenBg : AppColors.lightGray,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  isActive ? 'Activa' : 'Inactiva',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isActive ? AppColors.green : AppColors.grayText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(Icons.bolt, 'Consumo: $consumption'),
              const SizedBox(width: 16),
              _buildInfoChip(Icons.wifi, '$devices dispositivo(s) IoT'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.darkNavy,
                side: const BorderSide(color: AppColors.lightGray),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text(
                'Ver Detalle',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.grayText),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.grayText,
          ),
        ),
      ],
    );
  }
}
