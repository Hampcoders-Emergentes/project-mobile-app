import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/device_onboarding_data.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/device_type_selector.dart';

class Step1DeviceInfoPage extends StatefulWidget {
  const Step1DeviceInfoPage({super.key});

  @override
  State<Step1DeviceInfoPage> createState() => _Step1DeviceInfoPageState();
}

class _Step1DeviceInfoPageState extends State<Step1DeviceInfoPage> {
  String? _deviceType;
  double _nominalVoltage = 220;
  double _dailyUsageHours = 8;
  int _occupants = 3;
  String _locationType = 'Residential';
  final _primaryUseController = TextEditingController();

  static const _voltageOptions = [110.0, 220.0, 380.0];
  static const _locationOptions = ['Residential', 'Commercial', 'Industrial'];

  int _questionIndex = 0;

  @override
  void dispose() {
    _primaryUseController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _deviceType != null &&
      _primaryUseController.text.trim().isNotEmpty;

  void _submit() {
    if (!_isValid) return;

    final bloc = context.read<OnboardingBloc>();
    bloc.add(SubmitDeviceInfo(DeviceOnboardingRequest(
      deviceType: _deviceType!,
      nominalVoltage: _nominalVoltage,
      dailyUsageHours: _dailyUsageHours,
      occupants: _occupants,
      locationType: _locationType,
      primaryUse: _primaryUseController.text.trim(),
    )));
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = _questionIndex >= 5;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            children: [
              ChatBubble(
                text: '¡Hola! Voy a ayudarte a configurar tu dispositivo. '
                    '¿Qué tipo de equipo deseas monitorear?',
                isUser: false,
              ),
              if (_questionIndex >= 0) ...[
                const SizedBox(height: 8),
                DeviceTypeSelector(
                  selected: _deviceType,
                  onSelected: (v) => setState(() {
                    _deviceType = v;
                    _questionIndex = 1;
                  }),
                ),
              ],
              if (_deviceType != null) ...[
                ChatBubble(
                  text: 'Excelente. ¿Cuál es el voltaje nominal del equipo?',
                  isUser: false,
                ),
                const SizedBox(height: 8),
                _VoltageChips(
                  selected: _nominalVoltage,
                  options: _voltageOptions,
                  onSelected: (v) => setState(() {
                    _nominalVoltage = v;
                    _questionIndex = 2;
                  }),
                ),
              ],
              if (_questionIndex >= 2) ...[
                ChatBubble(
                  text: '¿Cuántas horas al día estará en uso?',
                  isUser: false,
                ),
                const SizedBox(height: 8),
                _SliderDisplay(
                  value: _dailyUsageHours,
                  min: 1,
                  max: 24,
                  divisions: 23,
                  suffix: 'h',
                  onChanged: (v) => setState(() {
                    _dailyUsageHours = v;
                    _questionIndex = 3;
                  }),
                ),
              ],
              if (_questionIndex >= 3) ...[
                ChatBubble(
                  text: '¿Cuántas personas ocupan el espacio?',
                  isUser: false,
                ),
                const SizedBox(height: 8),
                _SliderDisplay(
                  value: _occupants.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  suffix: '',
                  displayValue: '$_occupants',
                  onChanged: (v) => setState(() {
                    _occupants = v.toInt();
                    _questionIndex = 4;
                  }),
                ),
              ],
              if (_questionIndex >= 4) ...[
                ChatBubble(
                  text: '¿El equipo está en un entorno residencial, comercial o industrial?',
                  isUser: false,
                ),
                const SizedBox(height: 8),
                _LocationChips(
                  selected: _locationType,
                  options: _locationOptions,
                  onSelected: (v) => setState(() {
                    _locationType = v;
                    _questionIndex = 5;
                  }),
                ),
              ],
              if (_questionIndex >= 5) ...[
                ChatBubble(
                  text: '¿Cuál es el uso principal del dispositivo? '
                      'Cuéntame brevemente para ajustar mejor los umbrales.',
                  isUser: false,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: TextField(
                    controller: _primaryUseController,
                    decoration: InputDecoration(
                      hintText: 'Ej: Climatización de sala principal',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
        if (isComplete)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isValid ? _submit : null,
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
                  child: const Text(
                    'Analizar con IA',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _VoltageChips extends StatelessWidget {
  final double selected;
  final List<double> options;
  final ValueChanged<double> onSelected;

  const _VoltageChips({
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Wrap(
        spacing: 8,
        children: options.map((v) {
          final isSelected = selected == v;
          return ChoiceChip(
            label: Text('${v.toInt()}V'),
            selected: isSelected,
            onSelected: (_) => onSelected(v),
            selectedColor: AppColors.darkNavy,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.darkText,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected ? AppColors.darkNavy : const Color(0xFFE5E7EB),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LocationChips extends StatelessWidget {
  final String selected;
  final List<String> options;
  final ValueChanged<String> onSelected;

  const _LocationChips({
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Wrap(
        spacing: 8,
        children: options.map((loc) {
          final isSelected = selected == loc;
          return ChoiceChip(
            label: Text(loc),
            selected: isSelected,
            onSelected: (_) => onSelected(loc),
            selectedColor: AppColors.darkNavy,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.darkText,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected ? AppColors.darkNavy : const Color(0xFFE5E7EB),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SliderDisplay extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String suffix;
  final String? displayValue;
  final ValueChanged<double> onChanged;

  const _SliderDisplay({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.suffix,
    this.displayValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final label = displayValue ?? '${value.toInt()}';
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.darkNavy,
                  inactiveTrackColor: AppColors.darkNavy.withAlpha(25),
                  thumbColor: AppColors.darkNavy,
                  overlayColor: AppColors.darkNavy.withAlpha(20),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: value.clamp(min, max),
                  min: min,
                  max: max,
                  divisions: divisions,
                  onChanged: onChanged,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '$label$suffix',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
