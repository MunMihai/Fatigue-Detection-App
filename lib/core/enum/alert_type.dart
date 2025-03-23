import 'package:flutter/material.dart';

enum AlertType { drowsiness, sessionExpired, yawning }

extension AlertTypeExtension on AlertType {
  String get description {
    switch (this) {
      case AlertType.drowsiness:
        return 'Drowsiness detected';
      case AlertType.sessionExpired:
        return 'Session timer expired!';
      case AlertType.yawning:
        return 'Yawn';
    }
  }

    Color color(BuildContext context) {
    switch (this) {
      case AlertType.drowsiness:
        return Colors.red;
      case AlertType.sessionExpired:
        return Colors.white;
      case AlertType.yawning:
        return Colors.yellow; // 👈 Poți personaliza
    }
  }

}
