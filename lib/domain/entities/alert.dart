import 'package:driver_monitoring/domain/enum/fatigue_level.dart';
import 'package:flutter/widgets.dart';

class Alert {
  final String id;
  final String type;
  final DateTime timestamp;
  final double severity; 

  Alert({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.severity,
  });

  FatigueLevel get fatigueLevel => FatigueLevelExtension.fromScore(severity);
  String fatigueLevelLabel(BuildContext context) => fatigueLevel.label(context); 
}
