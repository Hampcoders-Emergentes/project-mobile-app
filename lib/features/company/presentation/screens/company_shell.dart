import 'package:flutter/material.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/widgets/main_shell.dart';

/// Punto de entrada para companies; la UI vive en [MainShell],
/// compartida con el rol homeowner.
class CompanyShell extends StatelessWidget {
  final int initialIndex;

  const CompanyShell({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return MainShell(role: UserRole.company, initialIndex: initialIndex);
  }
}
