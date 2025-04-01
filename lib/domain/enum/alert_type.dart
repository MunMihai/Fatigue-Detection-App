import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AlertType { drowsiness, sessionExpired, yawning }

extension AlertTypeExtension on AlertType {
  String localizedDescription(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    switch (this) {
      case AlertType.drowsiness:
        return tr.drowsiness;
      case AlertType.sessionExpired:
        return tr.sessionExpired;
      case AlertType.yawning:
        return tr.yawning;
    }
  }

}
