import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../device_onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../../device_onboarding/presentation/pages/onboarding_wizard_page.dart';
import '../../domain/models/iot_dashboard_data.dart';
import '../bloc/iot_dashboard_bloc.dart';
import '../bloc/iot_dashboard_event.dart';
import '../bloc/iot_dashboard_state.dart';
import '../utils/format.dart';
import '../widgets/circuit_table.dart';
import '../widgets/power_chart.dart';
import '../widgets/sensor_nodes_row.dart';
import '../widgets/updated_ago_label.dart';

const _okGreen = Color(0xFF006C49);

/// Monitoreo IoT unificado (homeowner y company) con telemetría real.
///
/// El control de relés / safety override quedó descopado a Fase 2:
/// no existen endpoints de actuación en el backend actual.
class IotMonitoringTab extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const IotMonitoringTab({super.key, this.onMenuTap});

  void _openOnboarding(BuildContext context) {
    final client = ApiClient(baseUrl: ApiEndpoints.baseUrl);
    final repo = OnboardingRepositoryImpl(client);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OnboardingWizardPage(repository: repo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: BlocBuilder<IotDashboardBloc, IotDashboardState>(
            builder: (context, state) {
              if (state is IotDashboardLoading ||
                  state is IotDashboardInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is IotDashboardError) {
                return _buildError(context, state.message);
              }
              if (state is IotDashboardLoaded) {
                return _buildBody(context, state.data);
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.appBarBg,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: onMenuTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              child:
                  const Icon(Icons.menu, size: 18, color: AppColors.darkNavy),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Monitoreo IoT',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
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
              style: const TextStyle(fontSize: 14, color: AppColors.grayText),
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

  Widget _buildBody(BuildContext context, IotDashboardData data) {
    final consumption = data.consumption;
    final circuits = consumption?.circuitSummaries ?? const [];
    return RefreshIndicator(
      color: AppColors.darkNavy,
      onRefresh: () async {
        context.read<IotDashboardBloc>().add(const RefreshIotDashboard());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'NODOS DE SENSORES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grayText,
                    letterSpacing: 0.6,
                  ),
                ),
                GestureDetector(
                  onTap: () => _openOnboarding(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.darkNavy,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Añadir dispositivo',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SensorNodesRow(circuits: circuits, now: data.fetchedAt),
            const SizedBox(height: 24),
            _buildPowerCard(data),
            const SizedBox(height: 24),
            CircuitTable(
              circuits: circuits,
              faultedCircuitIds: data.alerts.faultedCircuitIds,
              now: data.fetchedAt,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPowerCard(IotDashboardData data) {
    final consumption = data.consumption;
    final powerKw = consumption?.latestPowerKw;
    final hourChange = consumption?.percentChange(const Duration(hours: 1));
    final lastUpdated = consumption?.lastUpdatedAt ?? data.fetchedAt;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'POTENCIA DE LA INSTALACIÓN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grayText,
                  letterSpacing: 0.6,
                ),
              ),
              UpdatedAgoLabel(updatedAt: lastUpdated),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                powerKw != null ? IotFormat.number(powerKw) : '--',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -0.96,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'kW',
                style: TextStyle(fontSize: 20, color: AppColors.grayText),
              ),
            ],
          ),
          if (hourChange != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  hourChange <= 0 ? Icons.trending_down : Icons.trending_up,
                  size: 16,
                  color: hourChange <= 0 ? _okGreen : AppColors.errorRed,
                ),
                const SizedBox(width: 4),
                Text(
                  '${IotFormat.percent(hourChange)} vs hora anterior',
                  style: TextStyle(
                    fontSize: 14,
                    color: hourChange <= 0 ? _okGreen : AppColors.errorRed,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          PowerChart(series: consumption?.timeSeries ?? const []),
        ],
      ),
    );
  }
}
