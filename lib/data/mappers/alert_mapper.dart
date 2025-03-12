import 'package:driver_monitoring/domain/entities/alert.dart';
import 'package:driver_monitoring/data/models/alert_model.dart';

extension AlertMapper on Alert {
  AlertModel toModel({required String reportId}) {
    return AlertModel(
      id: id,
      type: type,
      timestamp: timestamp,
      severity: severity,
      reportId: reportId,
    );
  }
}

extension AlertModelMapper on AlertModel {
  Alert toEntity() {
    return Alert(
      id: id,
      type: type,
      timestamp: timestamp,
      severity: severity,
    );
  }
}
