import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../bloc/confirm_request_bloc.dart';
import '../bloc/confirm_request_event.dart';
import '../bloc/confirm_request_state.dart';
import '../widgets/property_detail_card.dart';
import '../widgets/technical_requirement_banner.dart';
import '../widgets/wizard_stepper.dart';

class ConfirmRequestPage extends StatelessWidget {
  const ConfirmRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConfirmRequestBloc(),
      child: const _ConfirmRequestView(),
    );
  }
}

class _ConfirmRequestView extends StatelessWidget {
  const _ConfirmRequestView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(showBack: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WizardStepper(currentStep: 2),
                    const SizedBox(height: 24),
                    const Text(
                      'Resumen de Solicitud',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Revise los detalles de la incidencia reportada\n'
                      'antes de confirmar la visita técnica.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grayText,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const PropertyDetailCard(),
                    const SizedBox(height: 16),
                    const TechnicalRequirementBanner(),
                    const SizedBox(height: 24),
                    BlocBuilder<ConfirmRequestBloc, ConfirmRequestState>(
                      builder: (context, state) {
                        if (state is ConfirmRequestLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (state is ConfirmRequestSuccess) {
                          return _buildSuccess(context);
                        }
                        return _buildActions(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.greenBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greenBorder),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, size: 48, color: AppColors.green),
          const SizedBox(height: 12),
          const Text(
            'Solicitud Confirmada',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context)
                  .popUntil((route) => route.isFirst),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkNavy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Volver al Inicio',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.darkNavy,
            side: const BorderSide(color: AppColors.darkNavy),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Volver',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.28,
            ),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            context.read<ConfirmRequestBloc>().add(const ConfirmRequest());
          },
          child: Container(
            padding: const EdgeInsets.only(
              left: 24,
              right: 48.2,
              top: 16,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.darkNavy,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded,
                    size: 18, color: Colors.white),
                SizedBox(width: 32.2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirmar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.28,
                      ),
                    ),
                    Text(
                      'Solicitud',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.28,
                      ),
                    ),
                    Text(
                      'Prioritaria',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.28,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
