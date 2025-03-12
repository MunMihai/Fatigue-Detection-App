import 'package:flutter/material.dart';

class DetailedSessionReportChart extends StatelessWidget {
  const DetailedSessionReportChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Fatigue evolution in the session\nAxa X - minutele\nAxa Y - oboseală (0-100)',
        textAlign: TextAlign.center,
      ),
    );
  }
}
