import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/device_onboarding_data.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/chat_bubble.dart';

class Step2AnalysisPage extends StatefulWidget {
  final DeviceOnboardingRequest request;

  const Step2AnalysisPage({super.key, required this.request});

  @override
  State<Step2AnalysisPage> createState() => _Step2AnalysisPageState();
}

class _Step2AnalysisPageState extends State<Step2AnalysisPage> {
  String _typedText = '';
  int _charIndex = 0;
  Timer? _typeTimer;

  @override
  void dispose() {
    _typeTimer?.cancel();
    super.dispose();
  }

  void _startTyping(String fullText) {
    _typeTimer?.cancel();
    setState(() {
      _typedText = '';
      _charIndex = 0;
    });
    _typeTimer = Timer.periodic(const Duration(milliseconds: 15), (timer) {
      if (_charIndex < fullText.length) {
        setState(() {
          _typedText = fullText.substring(0, _charIndex + 1);
          _charIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingStep2AnalysisResult) {
          if (state.analysis.narrative.isNotEmpty) {
            _startTyping(state.analysis.narrative);
          }
        }
      },
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          if (state is OnboardingStep2AnalysisResult) {
            final analysis = state.analysis;
            final isTypingComplete = _charIndex >= (analysis.narrative.length);
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChatBubble(
                    text: _typedText,
                    isTyping: !isTypingComplete,
                  ),
                  if (isTypingComplete && analysis.narrative.isNotEmpty)
                    const SizedBox(height: 4),
                  if (isTypingComplete) ...[
                    _buildReasoningChip(analysis.reasoning),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<OnboardingBloc>().add(
                                AdjustThreshold('nominalVoltage',
                                    analysis.suggestedThresholds.nominalVoltage),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkNavy,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Continuar con los umbrales sugeridos',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              children: [
                ChatBubble(
                  text: 'Analizando la configuración de tu ${_deviceLabel(widget.request.deviceType)}...',
                  isUser: false,
                ),
                const SizedBox(height: 12),
                const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.darkNavy,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        context.read<OnboardingBloc>().add(ResetOnboarding()),
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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

  String _deviceLabel(String type) {
    switch (type) {
      case 'HVAC': return 'HVAC';
      case 'WaterHeater': return 'Calentador';
      case 'Refrigerator': return 'Refrigerador';
      case 'SolarInverter': return 'Inversor Solar';
      case 'EVCharger': return 'Cargador EV';
      default: return 'Dispositivo';
    }
  }
}
