import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_event.dart';
import '../bloc/analytics_state.dart';
import '../widgets/anomaly_history.dart';
import '../widgets/circuit_comparison.dart';
import '../widgets/consumption_chart.dart';
import '../widgets/cost_projection_card.dart';
import '../widgets/period_tabs.dart';

class AnalyticsPage extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final bool showBack;

  const AnalyticsPage({super.key, this.onMenuTap, this.showBack = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnalyticsBloc(),
      child: Column(
        children: [
          AppTopBar(showBack: showBack, onMenuTap: onMenuTap),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Analytics de Consumo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkNavy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<AnalyticsBloc, AnalyticsState>(
                    builder: (context, state) {
                      return PeriodTabs(
                        selectedIndex: state.selectedPeriod,
                        onSelected: (index) {
                          context
                              .read<AnalyticsBloc>()
                              .add(SelectPeriod(index: index));
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const CostProjectionCard(),
                  const SizedBox(height: 24),
                  const ConsumptionChart(),
                  const SizedBox(height: 24),
                  const CircuitComparison(),
                  const SizedBox(height: 24),
                  const AnomalyHistory(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
