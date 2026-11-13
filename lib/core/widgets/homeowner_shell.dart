import 'package:flutter/material.dart';
import '../enums/user_role.dart';
import 'main_shell.dart';

/// Punto de entrada para homeowners; la UI vive en [MainShell],
/// compartida con el rol company.
class HomeownerShell extends StatelessWidget {
  final int initialIndex;

  const HomeownerShell({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return MainShell(role: UserRole.homeowner, initialIndex: initialIndex);
  }
}
