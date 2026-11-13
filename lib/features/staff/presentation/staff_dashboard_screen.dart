import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../data/staff_api.dart';
import '../data/staff_repository.dart';
import '../domain/staff_models.dart';
import 'staff_dashboard_controller.dart';
import 'staff_dashboard_content.dart';
import 'staff_equipment_screen.dart';
import 'staff_session.dart';
import 'staff_widgets.dart';

class StaffDashboardScreen extends StatefulWidget {
  final StaffRepository repository;
  final String email;
  const StaffDashboardScreen({
    super.key,
    required this.repository,
    required this.email,
  });
  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen>
    with WidgetsBindingObserver {
  late final StaffDashboardController controller;
  final _saving = <String>{};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = StaffDashboardController(widget.repository)..load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) controller.refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.close();
    super.dispose();
  }

  Future<void> _acknowledge(
    StaffStore store,
    StaffEquipment equipment,
    StaffAlert alert,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        title: const Text('Reconocer alerta'),
        content: const Text(
          'Se registrará que viste esta alerta. Reconocerla no resuelve la incidencia ni cambia el estado del equipo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reconocer'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted || _saving.contains(alert.id)) return;
    setState(() => _saving.add(alert.id));
    try {
      final updated = await widget.repository.acknowledge(
        store.id,
        equipment,
        alert,
      );
      if (!mounted || controller.state.selected?.id != store.id) return;
      final recognized = updated.status == 'ACKNOWLEDGED';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            recognized
                ? 'Alerta reconocida. La incidencia sigue pendiente de atención.'
                : 'El estado cambió. Se actualizará la lista.',
          ),
        ),
      );
      await controller.refresh();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(staffError(error))));
      }
    } finally {
      if (mounted) setState(() => _saving.remove(alert.id));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('ElectroLink'),
      actions: [
        IconButton(
          tooltip: 'Actualizar dashboard',
          onPressed: controller.refresh,
          icon: const Icon(Icons.refresh),
        ),
        IconButton(
          tooltip: 'Cerrar sesión',
          onPressed: () => context.read<StaffSession>().signOut(),
          icon: const Icon(Icons.logout),
        ),
      ],
    ),
    body: BlocBuilder<StaffDashboardController, StaffDashboardState>(
      bloc: controller,
      builder: (context, state) => RefreshIndicator(
        onRefresh: controller.refresh,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.darkNavy,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'OPERACIÓN DEL LOCAL',
                        style: TextStyle(
                          color: AppColors.accentYellow,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tu jornada, de un vistazo',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.email,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Revisa equipos y alertas antes de comenzar.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                if (state.stores.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  InputDecorator(
                    decoration: const InputDecoration(labelText: 'Local'),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: state.selected?.id,
                        items: state.stores
                            .map(
                              (s) => DropdownMenuItem(
                                value: s.id,
                                child: Text(
                                  s.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (id) {
                          if (id != null) {
                            controller.select(
                              state.stores.firstWhere((s) => s.id == id),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  if (state.selected != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(state.selected!.address),
                    ),
                ],
                if (state.loading)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: CircularProgressIndicator(
                        semanticsLabel: 'Consultando local',
                      ),
                    ),
                  ),
                if (state.error != null)
                  StaffMessage(
                    title: 'No pudimos actualizar el local',
                    message: state.error!,
                    retry: controller.refresh,
                  ),
                if (!state.loading &&
                    state.error == null &&
                    state.loadedStores &&
                    state.stores.isEmpty)
                  StaffMessage(
                    title: 'Sin locales disponibles',
                    message:
                        'Esta cuenta no tiene locales accesibles. Consulta con el responsable del local o ingresa con la cuenta de prueba autorizada.',
                    retry: controller.load,
                    action: 'Volver a consultar',
                  ),
                if (state.dashboard != null && state.alerts != null)
                  StaffDashboardContent(
                    state: state,
                    saving: _saving,
                    onAcknowledge: _acknowledge,
                    onOpenEquipment: (equipment) => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => StaffEquipmentScreen(
                          repository: widget.repository,
                          store: state.selected!,
                          equipment: equipment,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
