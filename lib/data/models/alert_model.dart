import 'package:driver_monitoring/domain/entities/alert.dart';

class AlertModel {
  final String id;
  final String type;
  final DateTime timestamp;  // Folosește DateTime pentru timestamp
  final double severity;
  final String reportId;

  AlertModel({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.severity,
    required this.reportId,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'],
      type: json['type'],
      timestamp: DateTime.parse(json['timestamp']),  // Conversie din string în DateTime
      severity: (json['severity'] as num).toDouble(),
      reportId: json['reportId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'timestamp': timestamp.toIso8601String(),  // Convertire DateTime în string
      'severity': severity,
      'reportId': reportId,
    };
  }

  Alert toEntity() {
    return Alert(
      id: id,
      type: type,
      timestamp: timestamp,
      severity: severity,
    );
  }

  factory AlertModel.fromEntity(Alert entity, String reportId) {
    return AlertModel(
      id: entity.id,
      type: entity.type,
      timestamp: entity.timestamp,
      severity: entity.severity,
      reportId: reportId,
    );
  }
}
