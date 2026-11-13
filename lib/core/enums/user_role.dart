import 'package:flutter/material.dart';

enum UserRole {
  homeowner,
  company,
  technician;

  String get label {
    switch (this) {
      case UserRole.homeowner:
        return 'Dueño de Hogar';
      case UserRole.company:
        return 'Empresa';
      case UserRole.technician:
        return 'Técnico';
    }
  }

  String get iconLabel {
    switch (this) {
      case UserRole.homeowner:
        return 'CH';
      case UserRole.company:
        return 'E';
      case UserRole.technician:
        return 'T';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.homeowner:
        return Icons.home;
      case UserRole.company:
        return Icons.business;
      case UserRole.technician:
        return Icons.build;
    }
  }
}
