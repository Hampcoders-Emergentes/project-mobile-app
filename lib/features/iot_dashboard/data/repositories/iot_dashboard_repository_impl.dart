import 'package:mobile_app_electrolink/core/enums/user_role.dart';
import 'package:mobile_app_electrolink/core/network/api_client.dart';
import 'package:mobile_app_electrolink/core/network/api_endpoints.dart';

import '../../domain/models/alert_log.dart';
import '../../domain/models/consumption_dashboard.dart';
import '../../domain/models/consumption_report.dart';
import '../../domain/models/iot_dashboard_data.dart';
import '../../domain/models/owner_context.dart';
import '../../domain/repositories/iot_dashboard_repository.dart';

class IotDashboardRepositoryImpl implements IotDashboardRepository {
  final ApiClient _client;
  final UserRole role;

  IotDashboardRepositoryImpl(this._client, {required this.role});

  OwnerContext? _cachedOwner;

  @override
  Future<IotDashboardData> getDashboard() async {
    final owner = await _resolveOwner();

    // Cada fuente degrada por separado: si una falla el resto sigue visible.
    final results = await Future.wait<Object?>([
      _tryGet<ConsumptionDashboard>(
        ApiEndpoints.consumptionDashboard(owner.ownerId),
        ConsumptionDashboard.fromJson,
      ),
      _tryGet<AlertLog>(
        ApiEndpoints.alertLog(owner.ownerId),
        AlertLog.fromJson,
      ),
      _tryGetReports(owner.ownerId),
    ]);

    return IotDashboardData(
      owner: owner,
      consumption: results[0] as ConsumptionDashboard?,
      alerts: (results[1] as AlertLog?) ?? AlertLog.empty,
      reports: (results[2] as List<ConsumptionReport>?) ?? const [],
      fetchedAt: DateTime.now().toUtc(),
    );
  }

  @override
  Future<void> acknowledgeAlert(String ownerId, String entryId) async {
    await _client.put(
      ApiEndpoints.acknowledgeAlert(ownerId),
      data: {'entryId': entryId},
    );
  }

  @override
  Future<void> linkAlertToService(
    String ownerId,
    String entryId,
    String serviceRequestId,
  ) async {
    await _client.put(
      ApiEndpoints.linkAlertToService(ownerId),
      data: {'entryId': entryId, 'serviceRequestId': serviceRequestId},
    );
  }

  /// El backend indexa por ownerId genérico: se usa el profileId de
  /// `/profiles/me` tanto para homeowner como para company.
  Future<OwnerContext> _resolveOwner() async {
    if (_cachedOwner != null) return _cachedOwner!;
    final response = await _client.get(ApiEndpoints.myProfile);
    final json = response.data as Map<String, dynamic>? ?? {};
    final firstName = json['firstName'] as String? ?? '';
    final lastName = json['lastName'] as String? ?? '';
    final companyName = json['companyName'] as String? ?? '';
    final name = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
    _cachedOwner = OwnerContext(
      ownerId: json['profileId'] as String? ?? '',
      displayName: name.isNotEmpty ? name : companyName,
      role: role,
    );
    return _cachedOwner!;
  }

  Future<T?> _tryGet<T>(
    String path,
    T Function(Map<String, dynamic>) parser,
  ) async {
    try {
      final response = await _client.get(path);
      final data = response.data;
      if (data is Map<String, dynamic>) return parser(data);
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<ConsumptionReport>?> _tryGetReports(String ownerId) async {
    try {
      final response =
          await _client.get(ApiEndpoints.consumptionReports(ownerId));
      final data = response.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(ConsumptionReport.fromJson)
            .toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
