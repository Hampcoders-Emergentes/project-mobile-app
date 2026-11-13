import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class WizardStepper extends StatelessWidget {
  final int currentStep;

  const WizardStepper({super.key, required this.currentStep});

  static const _steps = ['Propiedad', 'Diagnóstico', 'Confirmación'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              color: AppColors.profileBg,
            ),
          ),
          Positioned(
            left: 0,
            right: MediaQuery.of(context).size.width * 0.25,
            child: Container(
              height: 4,
              color: AppColors.darkNavy,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_steps.length, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted || isCurrent
                          ? AppColors.darkNavy
                          : AppColors.lightGray,
                      shape: BoxShape.circle,
                      border: isCurrent
                          ? Border.all(color: AppColors.darkNavy, width: 2)
                          : null,
                      boxShadow: isCurrent
                          ? const [
                              BoxShadow(
                                color: Color(0x332E3A59),
                                blurRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check,
                              size: 14, color: Colors.white)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isCurrent
                                    ? Colors.white
                                    : AppColors.grayText,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _steps[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isCurrent
                          ? AppColors.darkNavy
                          : AppColors.grayText,
                      letterSpacing: 0.12,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
