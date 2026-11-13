import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ConsumptionChart extends StatelessWidget {
  const ConsumptionChart({super.key});

  static const _days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Curva de Consumo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkNavy,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'kW/h',
                  style: TextStyle(fontSize: 11, color: AppColors.grayText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 208,
            child: CustomPaint(
              size: Size.infinite,
              painter: _ChartGridPainter(),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _LineChartPainter(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _days
                .map((d) => Text(
                      d,
                      style: const TextStyle(fontSize: 11, color: AppColors.grayText),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ChartGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightGray
      ..strokeWidth = 1;

    final dy = size.height / 4;
    for (int i = 1; i <= 3; i++) {
      canvas.drawLine(Offset(0, dy * i), Offset(size.width, dy * i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final values = [0.3, 0.5, 0.4, 0.7, 0.5, 0.6, 0.35];
    final paint = Paint()
      ..color = AppColors.primaryBlue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryBlue.withValues(alpha: 0.25),
          AppColors.primaryBlue.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();
    final dx = size.width / (values.length - 1);

    for (int i = 0; i < values.length; i++) {
      final x = dx * i;
      final y = size.height * (1 - values[i]);
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    for (int i = 0; i < values.length; i++) {
      final x = dx * i;
      final y = size.height * (1 - values[i]);
      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        Offset(x, y),
        3,
        Paint()..color = AppColors.primaryBlue,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
