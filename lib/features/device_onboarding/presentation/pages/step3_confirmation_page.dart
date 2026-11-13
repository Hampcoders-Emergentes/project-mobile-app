import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/auth/auth_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/device_onboarding_data.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/ia_input_bar.dart';
import '../widgets/threshold_slider_card.dart';

class Step3ConfirmationPage extends StatefulWidget {
  final DeviceOnboardingAnalysis analysis;

  const Step3ConfirmationPage({super.key, required this.analysis});

  @override
  State<Step3ConfirmationPage> createState() => _Step3ConfirmationPageState();
}

class _Step3ConfirmationPageState extends State<Step3ConfirmationPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final currentState = state is OnboardingStep3Adjusting ||
                state is OnboardingConfirming ||
                state is OnboardingConfirmError ||
                state is OnboardingAdjustingWithAI ||
                state is OnboardingAdjustError
            ? state
            : null;

        final analysis = currentState is OnboardingStep3Adjusting
            ? currentState.analysis
            : currentState is OnboardingConfirming
                ? currentState.analysis
                : currentState is OnboardingConfirmError
                    ? currentState.analysis
                    : currentState is OnboardingAdjustingWithAI
                        ? currentState.currentAnalysis
                        : currentState is OnboardingAdjustError
                            ? currentState.currentAnalysis
                            : widget.analysis;

        final thresholds = analysis.suggestedThresholds;
        final isConfirming = state is OnboardingConfirming;
        final confirmError =
            state is OnboardingConfirmError ? state.message : null;
        final isAdjustingWithAI = state is OnboardingAdjustingWithAI;
        final adjustError =
            state is OnboardingAdjustError ? state.message : null;

        return Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                children: [
                  ChatBubble(
                    text: analysis.narrative.isNotEmpty
                        ? analysis.narrative
                        : 'He analizado tu dispositivo y estos son los umbrales recomendados.',
                    isUser: false,
                  ),
                  if (analysis.reasoning.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _buildReasoningChip(analysis.reasoning),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    'Ajusta los umbrales manualmente o pídele a la IA que los modifique:',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.grayText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ThresholdSliderCard(
                    label: 'Voltaje nominal',
                    unit: 'V',
                    value: thresholds.nominalVoltage,
                    min: 100,
                    max: 400,
                    divisions: 30,
                    onChanged: (v) => context
                        .read<OnboardingBloc>()
                        .add(AdjustThreshold('nominalVoltage', v)),
                  ),
                  const SizedBox(height: 10),
                  ThresholdSliderCard(
                    label: 'Consumo máximo',
                    unit: 'W',
                    value: thresholds.maxConsumptionWatts,
                    min: 500,
                    max: 20000,
                    divisions: 40,
                    formatValue: (v) => '${v.toInt()}',
                    onChanged: (v) => context
                        .read<OnboardingBloc>()
                        .add(AdjustThreshold('maxConsumptionWatts', v)),
                  ),
                  const SizedBox(height: 10),
                  ThresholdSliderCard(
                    label: 'Corriente máxima',
                    unit: 'A',
                    value: thresholds.maxCurrentAmps,
                    min: 1,
                    max: 100,
                    divisions: 100,
                    onChanged: (v) => context
                        .read<OnboardingBloc>()
                        .add(AdjustThreshold('maxCurrentAmps', v)),
                  ),
                  const SizedBox(height: 10),
                  ThresholdSliderCard(
                    label: 'Factor de potencia',
                    unit: '',
                    value: thresholds.minPowerFactor,
                    min: 0.5,
                    max: 1.0,
                    divisions: 50,
                    formatValue: (v) => v.toStringAsFixed(2),
                    onChanged: (v) => context
                        .read<OnboardingBloc>()
                        .add(AdjustThreshold('minPowerFactor', v)),
                  ),
                  const SizedBox(height: 10),
                  ThresholdSliderCard(
                    label: 'Frecuencia nominal',
                    unit: 'Hz',
                    value: thresholds.nominalFrequency,
                    min: 50,
                    max: 60,
                    divisions: 10,
                    formatValue: (v) => '${v.toInt()}',
                    onChanged: (v) => context
                        .read<OnboardingBloc>()
                        .add(AdjustThreshold('nominalFrequency', v)),
                  ),
                  const SizedBox(height: 10),
                  ThresholdSliderCard(
                    label: 'Desconexión por inactividad',
                    unit: 'min',
                    value: thresholds.disconnectionThresholdMin.toDouble(),
                    min: 5,
                    max: 60,
                    divisions: 12,
                    formatValue: (v) => '${v.toInt()}',
                    onChanged: (v) => context
                        .read<OnboardingBloc>()
                        .add(AdjustThreshold(
                            'disconnectionThresholdMin', v.toInt())),
                  ),
                  if (confirmError != null || adjustError != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              size: 18, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              confirmError ?? adjustError!,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isConfirming || isAdjustingWithAI
                          ? null
                          : () {
                                final authState =
                                    context.read<AuthBloc>().state;
                                if (authState is AuthAuthenticated) {
                                  context
                                      .read<OnboardingBloc>()
                                      .add(ConfirmThresholds(
                                          authState.profileId));
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkNavy,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFE5E7EB),
                        disabledForegroundColor: AppColors.grayText,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isConfirming
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Confirmar y Guardar',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: isConfirming
                          ? null
                          : () => context
                              .read<OnboardingBloc>()
                              .add(ResetOnboarding()),
                      child: const Text('Volver al inicio'),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
            IaInputBar(
              isLoading: isAdjustingWithAI,
              onSend: (message) {
                final analysisId = analysis.analysisId;
                if (analysisId != null) {
                  context.read<OnboardingBloc>().add(
                        AdjustWithAI(
                          analysisId: analysisId,
                          userMessage: message,
                        ),
                      );
                  _scrollToBottom();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildReasoningChip(String reasoning) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCCD9FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline,
              size: 18, color: AppColors.darkNavy),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              reasoning,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.darkText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
