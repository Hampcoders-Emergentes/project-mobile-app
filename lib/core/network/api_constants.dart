class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://127.0.0.1:8088'; // <- Mac port for run flutter 
  // static const String baseUrl = 'http://10.0.2.2:8088';  // <- Android Studio emulator port for run flutter

  static const String signIn = '/api/v1/authentication/sign-in';
  static const String signUp = '/api/v1/authentication/sign-up';

  static const Duration connectTimeout = Duration(seconds: 5);
  static const Duration receiveTimeout = Duration(seconds: 5);
}
