import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../company/presentation/screens/nueva_solicitud_page.dart';
import '../bloc/service_request_bloc.dart';
import '../bloc/service_request_event.dart';
import '../bloc/service_request_state.dart';
import '../widgets/map_section.dart';
import '../widgets/progress_header.dart';
import '../widgets/property_chips.dart';
import '../widgets/service_category_card.dart';
import '../widgets/wizard_action_bar.dart';

class ServiceRequestPage extends StatelessWidget {
  const ServiceRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceRequestBloc(),
      child: const _ServiceRequestView(),
    );
  }
}

class _ServiceRequestView extends StatelessWidget {
  const _ServiceRequestView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(showBack: true),
            Expanded(
              child: BlocBuilder<ServiceRequestBloc, ServiceRequestState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProgressHeader(
                        currentStep: state.currentStep,
                        totalSteps: 4,
                        title: 'Ubicación y Servicio',
                      ),
                      const MapSection(),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PropertyChips(
                                selectedProperty: state.selectedProperty,
                                onSelected: (property) {
                                  context
                                      .read<ServiceRequestBloc>()
                                      .add(SelectProperty(property: property));
                                },
                              ),
                              const SizedBox(height: 24),
                              _buildServiceCategories(context, state),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            BlocBuilder<ServiceRequestBloc, ServiceRequestState>(
              builder: (context, state) {
                return WizardActionBar(
                  onBack: () => Navigator.of(context).pop(),
                  onContinue: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NuevaSolicitudPage(),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCategories(BuildContext context, ServiceRequestState state) {
    final categories = [
      (
        title: 'Instalación Eléctrica',
        subtitle: 'Cableado, tableros y puntos de',
        icon: Icons.bolt,
        isDark: true
      ),
      (
        title: 'Revisión Preventiva',
        subtitle: 'Diagnóstico y medición de…',
        icon: Icons.search,
        isDark: false
      ),
      (
        title: 'Configuración IoT',
        subtitle: 'Domótica y dispositivos…',
        icon: Icons.devices,
        isDark: false
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categoría de Servicio',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
            letterSpacing: 0.14,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(categories.length, (index) {
          final cat = categories[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index < categories.length - 1 ? 12 : 0),
            child: ServiceCategoryCard(
              index: index,
              title: cat.title,
              subtitle: cat.subtitle,
              icon: cat.icon,
              isDarkIcon: cat.isDark,
              isSelected: state.selectedServiceCategory == index,
              onTap: () {
                context
                    .read<ServiceRequestBloc>()
                    .add(SelectServiceCategory(index: index));
              },
            ),
          );
        }),
      ],
    );
  }
}
