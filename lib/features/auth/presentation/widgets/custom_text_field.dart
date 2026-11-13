import 'package:flutter/material.dart';
import 'package:mobile_app_electrolink/core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.controller,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final borderColor = hasError ? AppColors.errorRed : AppColors.borderLight;
    final focusedBorderColor = hasError ? AppColors.errorRed : AppColors.darkNavy;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: AppColors.grayText,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 16),
            prefixIcon: Icon(icon, size: 18, color: AppColors.grayText),
            suffixIcon: isPassword
                ? const Icon(Icons.visibility_off_outlined, size: 18, color: AppColors.grayText)
                : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: focusedBorderColor),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: AppColors.errorRed),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    errorText!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.errorRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}