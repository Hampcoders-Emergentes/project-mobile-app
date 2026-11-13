import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../analytics/presentation/pages/analytics_page.dart';
import '../../../service_request/presentation/pages/service_request_page.dart';
import '../../domain/models/alert_log.dart';
import '../../domain/models/iot_dashboard_data.dart';
import '../bloc/iot_dashboard_bloc.dart';
import '../bloc/iot_dashboard_event.dart';
import '../bloc/iot_dashboard_state.dart';
import '../utils/format.dart';
import '../widgets/activity_list.dart';
import '../widgets/alert_banner.dart';
import '../widgets/consumption_card.dart';
import '../widgets/metric_tiles.dart';

/// Home unificado: mismo contenido para homeowner y company,
/// alimentado por el consumption-dashboard del ownerId autenticado.
class IotHomeTab extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const IotHomeTab({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTopBar(onMenuTap: onMenuTap),
        Expanded(
          child: BlocBuilder<IotDashboardBloc, IotDashboardState>(
            builder: (context, state) {
              if (state is IotDashboardLoading ||
                  state is IotDashboardInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is IotDashboardError) {
                return _ErrorView(message: state.message);
              }
              if (state is IotDashboardLoaded) {
                return _HomeBody(data: state.data);
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}

class _HomeBody extends StatelessWidget {
  final IotDashboardData data;

  const _HomeBody({required this.data});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    final alert = data.activeAlert;
    final name = data.owner.displayName;
    return RefreshIndicator(
      color: AppColors.darkNavy,
      onRefresh: () async {
        context.read<IotDashboardBloc>().add(const RefreshIotDashboard());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name.isNotEmpty ? '$_greeting, $name' : _greeting,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Este es el estado de tus instalaciones hoy.',
              style: TextStyle(fontSize: 15, color: AppColors.grayText),
            ),
            const SizedBox(height: 24),
            if (alert != null) ...[
              AlertBanner(
                alert: alert,
                onViewDetails: () => _showAlertDetails(context, alert),
              ),
              const SizedBox(height: 16),
            ],
            ConsumptionCard(
              consumption: data.consumption,
              onTap: () => _openAnalytics(context),
            ),
            const SizedBox(height: 16),
            MetricTilesRow(
              consumption: data.consumption,
              now: data.fetchedAt,
            ),
            const SizedBox(height: 28),
            const Text(
              'Actividad Reciente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 12),
            ActivityList(items: data.activity),
          ],
        ),
      ),
    );
  }

  void _openAnalytics(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: SafeArea(child: AnalyticsPage(showBack: true)),
        ),
      ),
    );
  }

  void _showAlertDetails(BuildContext context, AlertLogEntry alert) {
    final bloc = context.read<IotDashboardBloc>();
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_rounded,
                      size: 24, color: AppColors.errorRed),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      alert.alertType,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (alert.circuitId.isNotEmpty)
                _DetailRow(label: 'Circuito', value: alert.circuitId),
              if (alert.triggeredAt != null)
                _DetailRow(
                  label: 'Detectada',
                  value: IotFormat.relative(alert.triggeredAt!),
                ),
              _DetailRow(label: 'Estado', value: alert.status),
              const SizedBox(height: 24),
              Row(
                children: [
                  if (!alert.isAcknowledged)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          bloc.add(AcknowledgeAlert(entryId: alert.entryId));
                          Navigator.of(sheetContext).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.darkNavy,
                          side: const BorderSide(color: AppColors.darkNavy),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Marcar como atendida'),
                      ),
                    ),
                  if (!alert.isAcknowledged) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ServiceRequestPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkNavy,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Solicitar servicio'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grayText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 40, color: AppColors.grayText),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grayText,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context
                  .read<IotDashboardBloc>()
                  .add(const FetchIotDashboard()),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.darkNavy,
                side: const BorderSide(color: AppColors.darkNavy),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
