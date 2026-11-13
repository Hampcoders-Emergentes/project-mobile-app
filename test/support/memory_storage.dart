import 'package:mobile_app_electrolink/features/staff/presentation/staff_session.dart';

class MemoryStorage implements SessionStorage {
  String? token;
  MemoryStorage([this.token]);
  @override
  Future<String?> read() async => token;
  @override
  Future<void> write(String token) async {
    this.token = token;
  }

  @override
  Future<void> clear() async {
    token = null;
  }
}
