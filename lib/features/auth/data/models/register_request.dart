import 'package:equatable/equatable.dart';

class RegisterRequest extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;
  final String role;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.role = 'Company',
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'passwordConfirmation': confirmPassword,
        'role': role,
      };

  @override
  List<Object> get props => [email, password, confirmPassword, role];
}
