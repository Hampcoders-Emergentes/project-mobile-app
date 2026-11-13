typedef Json = Map<String, dynamic>;
List<Json> jsonItems(dynamic value) =>
    (value as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
int _count(Json json, String key) => (json[key] as num).toInt();
DateTime _date(dynamic value) => DateTime.parse(value as String).toUtc();

class StaffStore {
  final String id, name, address;
  const StaffStore(this.id, this.name, this.address);
  factory StaffStore.fromJson(Json j) => StaffStore(
    j['id'] as String,
    j['name'] as String,
    j['address'] as String? ?? '',
  );
}

class StaffEquipment {
  final String id, name, areaId, areaName, state;
  const StaffEquipment(
    this.id,
    this.name,
    this.areaId,
    this.areaName,
    this.state,
  );
  factory StaffEquipment.fromJson(Json j) => StaffEquipment(
    j['equipmentId'] as String,
    j['name'] as String,
    j['areaId'] as String,
    j['areaName'] as String,
    j['state'] as String,
  );
  String get stateLabel => switch (state) {
    'NORMAL' => 'Lectura normal',
    'ANOMALY' => 'Anomalía detectada',
    'STALE' => 'Sin datos recientes',
    'UNKNOWN' => 'Sin lecturas',
    'UNMONITORED' => 'Sin sensor',
    _ => 'Estado desconocido',
  };
}

class StaffSummary {
  final String storeId;
  final DateTime generatedAt;
  final int total, monitored, offline, unmonitored;
  final List<StaffEquipment> equipment;
  const StaffSummary(
    this.storeId,
    this.generatedAt,
    this.total,
    this.monitored,
    this.offline,
    this.unmonitored,
    this.equipment,
  );
  factory StaffSummary.fromJson(Json j) => StaffSummary(
    j['storeId'] as String,
    _date(j['generatedAtUtc']),
    _count(j, 'totalEquipment'),
    _count(j, 'monitoredEquipment'),
    _count(j, 'offlineEquipment'),
    _count(j, 'unmonitoredEquipment'),
    jsonItems(j['equipment']).map(StaffEquipment.fromJson).toList(),
  );
}

class StaffAlert {
  final String id, equipmentId, type, severity, status;
  final String? description;
  final DateTime createdAt;
  const StaffAlert(
    this.id,
    this.equipmentId,
    this.type,
    this.severity,
    this.status,
    this.description,
    this.createdAt,
  );
  factory StaffAlert.fromJson(Json j) => StaffAlert(
    j['id'] as String,
    j['equipmentId'] as String,
    j['anomalyType'] as String,
    j['severity'] as String,
    j['status'] as String,
    j['description'] as String?,
    _date(j['createdAtUtc']),
  );
  String get title => switch (type) {
    'CURRENT_LEAKAGE' => 'Fuga de corriente',
    'OVERCURRENT' => 'Sobrecorriente',
    'OVERVOLTAGE' => 'Voltaje elevado',
    'UNDERVOLTAGE' => 'Voltaje bajo',
    'MANUAL_REPORT' => 'Reporte del personal',
    _ => 'Anomalía eléctrica ($type)',
  };
  String get statusLabel => switch (status) {
    'OPEN' => 'Pendiente',
    'ACKNOWLEDGED' => 'Reconocida',
    'ASSIGNED' => 'Asignada',
    'RESOLVED' => 'Resuelta',
    _ => 'Estado desconocido',
  };
}

class StaffAlerts {
  final int critical, nonCritical;
  final List<StaffAlert> items;
  const StaffAlerts(this.critical, this.nonCritical, this.items);
  factory StaffAlerts.fromJson(Json j) => StaffAlerts(
    _count(j, 'openCritical'),
    _count(j, 'openNonCritical'),
    jsonItems(j['items']).map(StaffAlert.fromJson).toList(),
  );
}

class StaffSafety {
  final String status;
  final bool safe;
  final DateTime evaluatedAt;
  final List<String> reasons;
  const StaffSafety(this.status, this.safe, this.evaluatedAt, this.reasons);
  factory StaffSafety.fromJson(Json j) => StaffSafety(
    j['status'] as String,
    j['isSafeToClean'] == true,
    _date(j['evaluatedAtUtc']),
    List<String>.from(j['reasons'] as List),
  );
  bool freshAt(DateTime now) {
    final age = now.toUtc().difference(evaluatedAt);
    return !age.isNegative && age < const Duration(minutes: 1);
  }

  bool canShowSafeAt(DateTime now) =>
      status == 'SAFE_TO_CLEAN' && safe && freshAt(now);
  String labelAt(DateTime now) {
    if (!freshAt(now)) return 'Evaluación vencida: vuelve a consultar';
    return switch (status) {
      'SAFE_TO_CLEAN' when safe => 'Apto para limpieza según la API',
      'ENERGIZED' => 'Equipo energizado',
      'HAZARD' => 'Riesgo detectado',
      _ => 'Seguridad sin verificar',
    };
  }
}

class StaffProtocol {
  final bool isDefault;
  final List<String> shutdown, isolation;
  const StaffProtocol(this.isDefault, this.shutdown, this.isolation);
  factory StaffProtocol.fromJson(Json j) => StaffProtocol(
    j['isDefault'] == true,
    List<String>.from(j['shutdownSteps'] as List),
    List<String>.from(j['emergencyIsolationSteps'] as List),
  );
}

class StaffEquipmentDetail {
  final StaffSafety safety;
  final StaffProtocol protocol;
  const StaffEquipmentDetail(this.safety, this.protocol);
}
