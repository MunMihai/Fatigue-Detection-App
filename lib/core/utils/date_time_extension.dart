import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

extension DateTimeFormat on DateTime {
  String toFormattedDate(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final formatter = DateFormat('MMMM dd, yyyy', locale);
    return formatter.format(this);
  }

  String toFormattedTime(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final formatter = DateFormat('hh:mm', locale);
    return formatter.format(this);
  }
}
