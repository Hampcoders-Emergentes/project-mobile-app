import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../data/staff_api.dart';
import '../data/staff_repository.dart';
import '../domain/staff_models.dart';
import 'staff_widgets.dart';

class StaffEquipmentScreen extends StatefulWidget {
  final StaffRepository repository;
  final StaffStore store;
  final StaffEquipment equipment;
  const StaffEquipmentScreen({
    super.key,
    required this.repository,
    required this.store,
    required this.equipment,
  });
  @override
  State<StaffEquipmentScreen> createState() => _StaffEquipmentScreenState();
}

class _StaffEquipmentScreenState extends State<StaffEquipmentScreen>
    with WidgetsBindingObserver {
  StaffEquipmentDetail? _detail;
  String? _error;
  bool _loading = true;
  int _generation = 0;
  Timer? _expiry;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  Future<void> _load() async {
    final generation = ++_generation;
    _expiry?.cancel();
    setState(() {
      _loading = true;
      _detail = null;
      _error = null;
    });
    try {
      final detail = await widget.repository.detail(
        widget.store.id,
        widget.equipment,
      );
      if (!mounted || generation != _generation) return;
      setState(() {
        _detail = detail;
        _loading = false;
      });
      final remaining = detail.safety.evaluatedAt
          .add(const Duration(minutes: 1))
          .difference(DateTime.now().toUtc());
      if (remaining > Duration.zero) {
        _expiry = Timer(remaining, () {
          if (mounted) setState(() {});
        });
      }
    } catch (error) {
      if (mounted && generation == _generation) {
        setState(() {
          _loading = false;
          _error = staffError(error);
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _load();
    } else {
      ++_generation;
      _expiry?.cancel();
      setState(() {
        _detail = null;
        _loading = false;
        _error = 'Consulta nuevamente para obtener una evaluación actual.';
      });
    }
  }

  @override
  void dispose() {
    _expiry?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Detalle del equipo'),
      actions: [
        IconButton(
          tooltip: 'Actualizar equipo',
          onPressed: _load,
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 840),
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Text(
                widget.equipment.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('${widget.store.name} · ${widget.equipment.areaName}'),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: CircularProgressIndicator(
                      semanticsLabel: 'Consultando evaluación',
                    ),
                  ),
                ),
              if (_error != null)
                StaffMessage(
                  title: 'Evaluación no disponible',
                  message: _error!,
                  retry: _load,
                ),
              if (_detail != null) ..._details(_detail!),
            ],
          ),
        ),
      ),
    ),
  );
  List<Widget> _details(StaffEquipmentDetail detail) {
    final safety = detail.safety, now = DateTime.now().toUtc();
    final safe = safety.canShowSafeAt(now);
    return [
      StaffSection(
        title: 'Estado para limpieza',
        child: StaffPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                safe ? Icons.check_circle_outline : Icons.info_outline,
                color: safe ? const Color(0xFF166534) : AppColors.errorRed,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                safety.labelAt(now),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Evaluado ${staffTime(safety.evaluatedAt)} · hora del dispositivo',
              ),
              const SizedBox(height: 8),
              const Text(
                'Resultado de la consulta al servidor. La evaluación se invalida después de un minuto o al salir de la app.',
              ),
              const SizedBox(height: 12),
              ...safety.reasons.map(
                (reason) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('• $reason'),
                ),
              ),
              if (!safety.freshAt(now))
                OutlinedButton(
                  onPressed: _load,
                  child: const Text('Consultar de nuevo'),
                ),
            ],
          ),
        ),
      ),
      StaffSection(
        title: 'Protocolo de apagado',
        child: StaffPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (detail.protocol.isDefault)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Protocolo general del servidor. El local todavía no tiene uno personalizado para este equipo.',
                  ),
                ),
              ..._steps(detail.protocol.shutdown),
            ],
          ),
        ),
      ),
      StaffSection(
        title: 'Aislamiento de emergencia',
        child: StaffPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _steps(detail.protocol.isolation),
          ),
        ),
      ),
    ];
  }

  List<Widget> _steps(List<String> steps) => steps.indexed
      .map(
        (step) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text('${step.$1 + 1}. ${step.$2}'),
        ),
      )
      .toList();
}
