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

}
