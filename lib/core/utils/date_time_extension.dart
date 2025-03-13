import 'package:intl/intl.dart';

extension DateTimeFormat on DateTime {
  String toFormattedDate() {
    final formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(this);
  }

  String toFormattedTime() {
    final formatter = DateFormat('hh:mm');
    return formatter.format(this);
  }
}
