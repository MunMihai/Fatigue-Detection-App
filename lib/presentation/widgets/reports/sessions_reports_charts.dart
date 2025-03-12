import 'package:flutter/material.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';

class SessionsReportsChart extends StatelessWidget {
  final List<SessionReport> reports; // 👈 Adăugat parametrul

  const SessionsReportsChart({
    super.key,
    required this.reports, // 👈 obligatoriu acum!
  });

  @override
  Widget build(BuildContext context) {
    // Poți folosi rapoartele aici pentru a genera chart-ul
    return Container(
      height: 200,
      color: Colors.blueGrey,
      child: Center(
        child: Text(
          'Total Sessions: ${reports.length}', // 👈 doar ca exemplu!
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
