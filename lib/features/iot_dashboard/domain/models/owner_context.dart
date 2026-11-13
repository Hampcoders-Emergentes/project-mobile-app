import 'package:equatable/equatable.dart';
import '../../../../core/enums/user_role.dart';

/// Identidad neutral del dueño de los datos IoT.
///
/// El backend indexa por `ownerId` sin importar si es homeowner o company;
/// el rol solo decide el cascarón visual (shell) y módulos adicionales.
class OwnerContext extends Equatable {
  final String ownerId;
  final String displayName;
  final UserRole role;

  const OwnerContext({
    required this.ownerId,
    required this.displayName,
    required this.role,
  });

  @override
  List<Object> get props => [ownerId, displayName, role];
}
