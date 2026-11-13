import '../models/iot_dashboard_data.dart';

abstract class IotDashboardRepository {
  Future<IotDashboardData> getDashboard();

  Future<void> acknowledgeAlert(String ownerId, String entryId);

  Future<void> linkAlertToService(
    String ownerId,
    String entryId,
    String serviceRequestId,
  );
}
