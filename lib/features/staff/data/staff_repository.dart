import '../domain/staff_models.dart';
import 'staff_api.dart';

class StaffRepository {
  final StaffApi api;
  const StaffRepository(this.api);
  String storePath(String id) => '/api/v1/stores/${Uri.encodeComponent(id)}';
  String equipmentPath(String storeId, StaffEquipment equipment) =>
      '${storePath(storeId)}/areas/${Uri.encodeComponent(equipment.areaId)}/equipment/${Uri.encodeComponent(equipment.id)}';

  Future<Json> _get(String path, {Json? query}) async {
    final response = await api.dio.get<Json>(path, queryParameters: query);
    if (response.data == null) throw const FormatException('Empty response');
    return response.data!;
  }

  Future<List<StaffStore>> stores() async {
    final stores = <StaffStore>[];
    var page = 1;
    while (true) {
      final data = await _get(
        '/api/v1/stores',
        query: {'page': page, 'pageSize': 100},
      );
      final rows = jsonItems(data['items']);
      stores.addAll(rows.map(StaffStore.fromJson));
      if (data['hasMore'] == false) return stores;
      if (data['hasMore'] != true || rows.isEmpty) {
        throw const FormatException('Invalid pagination');
      }
      page++;
    }
  }

  Future<StaffSummary> summary(String storeId) async => StaffSummary.fromJson(
    await _get('${storePath(storeId)}/dashboard-summary'),
  );
  Future<StaffAlerts> alerts(String storeId) async =>
      StaffAlerts.fromJson(await _get('${storePath(storeId)}/alerts/active'));
  Future<StaffAlert> acknowledge(
    String storeId,
    StaffEquipment equipment,
    StaffAlert alert,
  ) async {
    final response = await api.dio.post<Json>(
      '${equipmentPath(storeId, equipment)}/alerts/${Uri.encodeComponent(alert.id)}/acknowledgement',
    );
    return StaffAlert.fromJson(response.data!);
  }

  Future<StaffEquipmentDetail> detail(
    String storeId,
    StaffEquipment equipment,
  ) async {
    final path = equipmentPath(storeId, equipment);
    final results = await Future.wait([
      _get('$path/safety-status'),
      _get('$path/shutdown-protocol'),
    ]);
    return StaffEquipmentDetail(
      StaffSafety.fromJson(results[0]),
      StaffProtocol.fromJson(results[1]),
    );
  }
}
