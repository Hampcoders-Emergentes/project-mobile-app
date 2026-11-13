class ApiEndpoints {
  static const String baseUrl = 'http://127.0.0.1:8088';  // <- Mac port for run flutter
  // static const String baseUrl = 'http://10.0.2.2:8088';  // <- Android Studio emulator port for run flutter

  // El backend :8088 sirve todas sus rutas bajo /api/v1 (igual que ApiConstants).
  static const String _v1 = '/api/v1';

  static const String analyzeOnboarding =

      '/profiles/me/device-onboarding/analyze';
  static const String adjustOnboarding =
      '/profiles/me/device-onboarding/adjust';


  static String thresholds(String profileId) =>
      '$_v1/profiles/$profileId/thresholds';

  static const String completeHomeowner = '$_v1/profiles/me/complete/homeowner';

  static const String myProfile = '$_v1/profiles/me';
  static const String mySubscription = '$_v1/subscriptions/me';
  static const String myPaymentHistory = '$_v1/subscriptions/me/payment-history';
  static const String checkout = '$_v1/subscriptions/checkout';
  static const String cancelSubscription = '$_v1/subscriptions/me/cancel';
  static const String customerPortal = '$_v1/subscriptions/me/portal';

  // Alert Log — el path dice homeownerId pero el dominio usa ownerId genérico.
  static String alertLog(String ownerId) => '$_v1/alert-log/$ownerId';
  static String acknowledgeAlert(String ownerId) =>
      '$_v1/alert-log/$ownerId/acknowledge';
  static String linkAlertToService(String ownerId) =>
      '$_v1/alert-log/$ownerId/link-to-service';

  // Consumption Dashboard
  static String consumptionDashboard(String ownerId) =>
      '$_v1/consumption-dashboard/$ownerId';
  static String costProjection(String ownerId) =>
      '$_v1/consumption-dashboard/$ownerId/cost-projection';
  static String upgradeTier(String ownerId) =>
      '$_v1/consumption-dashboard/$ownerId/upgrade-tier';
  static String consumptionThresholds(String ownerId) =>
      '$_v1/consumption-dashboard/$ownerId/thresholds';

  // Consumption Reports
  static String consumptionReports(String ownerId) =>
      '$_v1/consumption-report/by-client/$ownerId';
  static const String requestConsumptionReport = '$_v1/consumption-report/request';

  // Property Portfolios (solo companies)
  static String propertyPortfolio(String ownerId) =>
      '$_v1/companies/$ownerId/property-portfolios';
}
