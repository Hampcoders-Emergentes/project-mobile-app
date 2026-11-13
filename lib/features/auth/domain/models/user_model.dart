import 'package:equatable/equatable.dart';
import 'package:mobile_app_electrolink/core/enums/user_role.dart';

class UserModel extends Equatable {
  final int userId;
  final String email;
  final String token;
  final UserRole role;

  const UserModel({
    required this.userId,
    required this.email,
    required this.token,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, email, token, role];
}
