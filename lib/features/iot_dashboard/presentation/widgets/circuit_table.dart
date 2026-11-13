import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/consumption_dashboard.dart';
import '../utils/format.dart';

const _liveGreen = Color(0xFF006C49);
const _offGray = Color(0xFF76777D);

enum _CircuitStatus { live, fault, offline }

/// Tabla de circuitos con datos reales de `circuitSummaries`.
///
/// Estado derivado localmente: Falla si el circuito tiene una alerta sin
/// resolver; Sin señal si no reporta lecturas hace más de 5 minutos.
/// Las columnas son PICO (A) / PICO (V): el backend entrega valores pico,
/// no lecturas instantáneas.
class CircuitTable extends StatelessWidget {
  final List<CircuitSummary> circuits;
  final Set<String> faultedCircuitIds;
  final DateTime now;

  const CircuitTable({
    super.key,
    required this.circuits,
    required this.faultedCircuitIds,
    required this.now,
  });

  _CircuitStatus _statusOf(CircuitSummary circuit) {
    if (faultedCircuitIds.contains(circuit.circuitId)) {
      return _CircuitStatus.fault;
    }
    return circuit.isOnline(now) ? _CircuitStatus.live : _CircuitStatus.offline;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
            decoration: const BoxDecoration(
              color: Color(0xFFF7F9FB),
              border: Border(
                bottom: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: const Text(
              'DETALLE POR CIRCUITO',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.grayText,
                letterSpacing: 0.6,
              ),
            ),
          ),
          if (circuits.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Sin circuitos registrados',
                  style: TextStyle(fontSize: 14, color: AppColors.grayText),
                ),
              ),
            )
          else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.borderLight),
                ),
              ),
              child: const Row(
                children: [
                  Expanded(flex: 3, child: _HeaderCell('CIRCUITO')),
                  Expanded(flex: 2, child: _HeaderCell('ESTADO')),
                  Expanded(
                      flex: 2,
                      child: _HeaderCell('PICO\n(A)', alignRight: true)),
                  Expanded(
                      flex: 2,
                      child: _HeaderCell('PICO\n(V)', alignRight: true)),
                ],
              ),
            ),
            for (var i = 0; i < circuits.length; i++) ...[
              if (i > 0)
                Container(
                  height: 1,
                  color: AppColors.borderLight.withAlpha(77),
                ),
              _CircuitRow(
                circuit: circuits[i],
                status: _statusOf(circuits[i]),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final bool alignRight;

  const _HeaderCell(this.text, {this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _offGray,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _CircuitRow extends StatelessWidget {
  final CircuitSummary circuit;
  final _CircuitStatus status;

  const _CircuitRow({required this.circuit, required this.status});

  Color get _statusColor => switch (status) {
        _CircuitStatus.live => _liveGreen,
        _CircuitStatus.fault => AppColors.errorRed,
        _CircuitStatus.offline => _offGray,
      };

  String get _statusLabel => switch (status) {
        _CircuitStatus.live => 'En vivo',
        _CircuitStatus.fault => 'Falla',
        _CircuitStatus.offline => 'Sin señal',
      };

  @override
  Widget build(BuildContext context) {
    final isFault = status == _CircuitStatus.fault;
    final valueColor = isFault
        ? AppColors.errorRed
        : (status == _CircuitStatus.offline ? _offGray : Colors.black);
    final current =
        isFault ? '--' : IotFormat.number(circuit.peakCurrent);
    final voltage =
        isFault ? '--' : IotFormat.number(circuit.peakVoltage, decimals: 0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                circuit.circuitId,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _statusLabel,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              current,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
                color: valueColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              voltage,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
