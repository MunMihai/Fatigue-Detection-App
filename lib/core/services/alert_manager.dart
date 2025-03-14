import 'package:flutter/foundation.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';

class AlertManager extends ChangeNotifier {
  final List<Alert> _alerts = [];

  List<Alert> get alerts => List.unmodifiable(_alerts);

  double get averageSeverity => _calculateAverageSeverity();

  void addAlert(Alert alert) {
    _alerts.add(alert);
    notifyListeners();
  }

  void clearAlerts() {
    _alerts.clear();
    notifyListeners();
  }

  double _calculateAverageSeverity() {
    if (_alerts.isEmpty) return 0.0;
    final total = _alerts.fold(0.0, (sum, alert) => sum + alert.severity);
    return total / _alerts.length;
  }
}
