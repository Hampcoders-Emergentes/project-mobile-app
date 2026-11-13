import 'package:mobile_app_electrolink/features/auth/domain/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String confirmPassword);
  Future<void> signOut();
  Future<String?> getToken();
  Future<bool> isAuthenticated();
}
