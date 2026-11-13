import 'package:equatable/equatable.dart';

class SignInResponse extends Equatable {
  final int userId;
  final String email;
  final String token;
  final String role;

  const SignInResponse({
    required this.userId,
    required this.email,
    required this.token,
    required this.role,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    final rawUserId = json['userId'] ?? json['user_id'];
    return SignInResponse(
      userId: rawUserId is int
          ? rawUserId
          : int.tryParse(rawUserId?.toString() ?? '') ?? 0,
      email: json['email'] as String? ?? '',
      token: json['token'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }

  @override
  List<Object> get props => [userId, email, token, role];
}
