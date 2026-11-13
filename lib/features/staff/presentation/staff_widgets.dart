import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

String staffTime(DateTime date) {
  final local = date.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(local.day)}/${two(local.month)} ${two(local.hour)}:${two(local.minute)}';
}

class StaffMessage extends StatelessWidget {
  final String title, message;
  final VoidCallback retry;
  final String action;
  const StaffMessage({
    super.key,
    required this.title,
    required this.message,
    required this.retry,
    this.action = 'Reintentar',
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.info_outline, size: 36, color: AppColors.darkNavy),
        const SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(message),
        const SizedBox(height: 16),
        OutlinedButton(onPressed: retry, child: Text(action)),
      ],
    ),
  );
}

class StaffSection extends StatelessWidget {
  final String title;
  final Widget child;
  const StaffSection({super.key, required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}

class StaffPanel extends StatelessWidget {
  final Widget child;
  const StaffPanel({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      border: Border.all(color: AppColors.lightGray),
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
}
