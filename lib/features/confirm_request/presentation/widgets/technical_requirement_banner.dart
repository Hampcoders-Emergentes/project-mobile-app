import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TechnicalRequirementBanner extends StatelessWidget {
  const TechnicalRequirementBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0x4DFFDAD6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.errorRed.withValues(alpha: 0.5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline,
              size: 19, color: Color(0xFF93000A)),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Requisito Técnico',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF93000A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Este servicio requiere un técnico\n'
                  'certificado en IoT para garantizar\n'
                  'la correcta configuración y\n'
                  'seguridad del dispositivo.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xCC93000A),
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
