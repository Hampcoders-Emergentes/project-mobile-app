import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final String iconText;

  const SocialButton({
    super.key,
    required this.label,
    required this.iconText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Center(
        child: label == 'Google'
            ? const Icon(Icons.g_mobiledata, size: 40, color: Colors.red)
            : const Icon(Icons.apple, size: 25, color: Colors.black),
      ),
    );
  }
}