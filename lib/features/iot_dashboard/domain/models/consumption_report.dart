import 'package:equatable/equatable.dart';

class ConsumptionReport extends Equatable {
  final String reportId;
  final String ownerId;
  final String propertyId;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final DateTime? generatedAt;
  final String exportFormat;
  final String downloadUrl;
  final DateTime? expiresAt;
  final bool isGenerated;

  const ConsumptionReport({
    required this.reportId,
    required this.ownerId,
    required this.propertyId,
    this.periodStart,
    this.periodEnd,
    this.generatedAt,
    required this.exportFormat,
    required this.downloadUrl,
    this.expiresAt,
    required this.isGenerated,
  });

  factory ConsumptionReport.fromJson(Map<String, dynamic> json) {
    return ConsumptionReport(
      reportId: json['reportId'] as String? ?? '',
      ownerId: json['ownerId'] as String? ?? '',
      propertyId: json['propertyId'] as String? ?? '',
      periodStart:
          DateTime.tryParse(json['periodStart'] as String? ?? '')?.toUtc(),
      periodEnd:
          DateTime.tryParse(json['periodEnd'] as String? ?? '')?.toUtc(),
      generatedAt:
          DateTime.tryParse(json['generatedAt'] as String? ?? '')?.toUtc(),
      exportFormat: json['exportFormat'] as String? ?? '',
      downloadUrl: json['downloadUrl'] as String? ?? '',
      expiresAt:
          DateTime.tryParse(json['expiresAt'] as String? ?? '')?.toUtc(),
      isGenerated: json['isGenerated'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        reportId,
        ownerId,
        propertyId,
        periodStart,
        periodEnd,
        generatedAt,
        exportFormat,
        downloadUrl,
        expiresAt,
        isGenerated,
      ];
}
