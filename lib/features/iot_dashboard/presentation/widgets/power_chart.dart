import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/consumption_dashboard.dart';
import '../utils/format.dart';

/// Curva de consumo dibujada desde `timeSeries` real (últimos puntos).
class PowerChart extends StatelessWidget {
  final List<TimeSeriesPoint> series;

  const PowerChart({super.key, required this.series});

  static const int _maxPoints = 24;

  @override
  Widget build(BuildContext context) {
    final points = series.length > _maxPoints
        ? series.sublist(series.length - _maxPoints)
        : series;
    if (points.length < 2) {
      return const SizedBox(
        height: 192,
        child: Center(
          child: Text(
            'Sin datos de consumo aún',
            style: TextStyle(fontSize: 14, color: AppColors.grayText),
          ),
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 192,
          child: CustomPaint(
            painter: _SeriesPainter(points: points),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              IotFormat.clock(points.first.timestamp),
              style: const TextStyle(fontSize: 12, color: Color(0xFF76777D)),
            ),
            Text(
              IotFormat.clock(points[points.length ~/ 2].timestamp),
              style: const TextStyle(fontSize: 12, color: Color(0xFF76777D)),
            ),
            const Text(
              'Ahora',
              style: TextStyle(fontSize: 12, color: Color(0xFF76777D)),
            ),
          ],
        ),
      ],
    );
  }
}

class _SeriesPainter extends CustomPainter {
  final List<TimeSeriesPoint> points;

  _SeriesPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.borderLight.withAlpha(77)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = 0; i < 4; i++) {
      final y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    double minV = points.first.kilowattHours;
    double maxV = points.first.kilowattHours;
    for (final p in points) {
      if (p.kilowattHours < minV) minV = p.kilowattHours;
      if (p.kilowattHours > maxV) maxV = p.kilowattHours;
    }
    final range = (maxV - minV).abs() < 1e-9 ? 1.0 : maxV - minV;

    Offset toOffset(int index) {
      final x = size.width * (index / (points.length - 1));
      // Margen vertical del 10% para que la curva no toque los bordes.
      final normalized = (points[index].kilowattHours - minV) / range;
      final y = size.height * (0.9 - normalized * 0.8);
      return Offset(x, y);
    }

    final path = Path()..moveTo(toOffset(0).dx, toOffset(0).dy);
    for (var i = 1; i < points.length; i++) {
      final prev = toOffset(i - 1);
      final curr = toOffset(i);
      final controlX = (prev.dx + curr.dx) / 2;
      path.cubicTo(controlX, prev.dy, controlX, curr.dy, curr.dx, curr.dy);
    }

    final linePaint = Paint()
      ..color = const Color(0xFF1F2937)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    // Punto sobre la última lectura.
    final lastOffset = toOffset(points.length - 1);
    canvas.drawCircle(lastOffset, 4, Paint()..color = const Color(0xFF1F2937));
    canvas.drawCircle(
      lastOffset,
      8,
      Paint()
        ..color = AppColors.errorRed
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _SeriesPainter oldDelegate) =>
      oldDelegate.points != points;
}
