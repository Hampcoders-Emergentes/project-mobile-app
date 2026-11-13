import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_top_bar.dart';

class CompanyAnalyticsPage extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const CompanyAnalyticsPage({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTopBar(onMenuTap: onMenuTap),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analytics en Tiempo Real',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkNavy,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Monitoreo IoT por circuito con datos en tiempo real.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grayText,
                  ),
                ),
                const SizedBox(height: 20),
                _buildPeriodSelector(),
                const SizedBox(height: 20),
                _buildConsumptionOverview(),
                const SizedBox(height: 20),
                _buildCircuitComparison(),
                const SizedBox(height: 20),
                _buildCostProjection(),
                const SizedBox(height: 20),
                _buildAlertHistory(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildPeriodTab('24H', true),
          _buildPeriodTab('7D', false),
          _buildPeriodTab('30D', false),
          _buildPeriodTab('12M', false),
        ],
      ),
    );
  }

  Widget _buildPeriodTab(String label, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.darkNavy : AppColors.grayText,
          ),
        ),
      ),
    );
  }

  Widget _buildConsumptionOverview() {
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
          const Text(
            'Consumo Total',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildConsumptionMetric('Actual', '12,500', 'kWh'),
              ),
              Container(height: 40, width: 1, color: AppColors.lightGray),
              Expanded(
                child: _buildConsumptionMetric('Pico Máx', '228.1', 'V'),
              ),
              Container(height: 40, width: 1, color: AppColors.lightGray),
              Expanded(
                child: _buildConsumptionMetric('Corriente', '45.3', 'A'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildMiniChart(),
        ],
      ),
    );
  }

  Widget _buildConsumptionMetric(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.darkNavy,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.grayText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.grayText,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniChart() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CustomPaint(
        size: const Size(double.infinity, 64),
        painter: _ChartLinePainter(),
      ),
    );
  }

  Widget _buildCircuitComparison() {
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
          const Text(
            'Resumen por Circuito',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 16),
          _buildCircuitRow('Circuito 1 - Piso 1', 5200, 228.1, 45.3),
          const Divider(height: 24, color: AppColors.lightGray),
          _buildCircuitRow('Circuito 2 - Piso 2', 4100, 226.8, 38.7),
          const Divider(height: 24, color: AppColors.lightGray),
          _buildCircuitRow('Circuito 3 - Equipos', 3200, 225.2, 28.5),
        ],
      ),
    );
  }

  Widget _buildCircuitRow(String name, int kwh, double voltage, double current) {
    final maxKwh = 6000.0;
    final ratio = kwh / maxKwh;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.darkText,
              ),
            ),
            Text(
              '$kwh kWh',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.darkNavy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio.clamp(0.0, 1.0),
            backgroundColor: AppColors.lightGray,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '${voltage.toStringAsFixed(1)}V',
              style: const TextStyle(fontSize: 11, color: AppColors.grayText),
            ),
            const SizedBox(width: 16),
            Text(
              '${current.toStringAsFixed(1)}A',
              style: const TextStyle(fontSize: 11, color: AppColors.grayText),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCostProjection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E3A59),
            Color(0xFF182442),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Proyección de Costo Mensual',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'S/5,200',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  '/mes',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xAAFFFFFF),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0x1AFFFFFF),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up, size: 14, color: Color(0xFF4ADE80)),
                    SizedBox(width: 4),
                    Text(
                      '+8.3%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4ADE80),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Basado en el consumo actual en tiempo real',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xAAFFFFFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertHistory() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Alertas Recientes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkNavy,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Ver todo',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkNavy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildAlertRow('Sobrecarga Sostenida', 'Circuito 1', 'MEDIUM', true),
          const Divider(height: 20, color: AppColors.lightGray),
          _buildAlertRow('Dispositivo Desconectado', 'Sucursal Surco', 'HIGH', false),
        ],
      ),
    );
  }

  Widget _buildAlertRow(String type, String location, String severity, bool isActive) {
    Color severityColor;
    switch (severity) {
      case 'HIGH':
        severityColor = AppColors.errorRed;
        break;
      case 'MEDIUM':
        severityColor = Colors.orange;
        break;
      default:
        severityColor = AppColors.grayText;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: severityColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            isActive ? Icons.warning_amber : Icons.check_circle_outline,
            size: 16,
            color: severityColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkText,
                ),
              ),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.grayText,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: severityColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            severity,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: severityColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChartLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryBlue.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final points = [0.3, 0.5, 0.4, 0.7, 0.6, 0.8, 0.75, 0.9, 0.7, 0.85, 0.8, 0.95];
    final path = Path();
    final stepX = size.width / (points.length - 1);

    path.moveTo(0, size.height);
    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      final y = size.height - (points[i] * size.height);
      if (i == 0) {
        path.lineTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    final linePath = Path();
    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      final y = size.height - (points[i] * size.height);
      if (i == 0) {
        linePath.moveTo(x, y);
      } else {
        linePath.lineTo(x, y);
      }
    }
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
