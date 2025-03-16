import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:driver_monitoring/presentation/widgets/buttomNavigationBar/bottom_navigation_bar_active.dart';
import 'package:driver_monitoring/presentation/widgets/camera_previw_wiget.dart';
import 'package:flutter/material.dart';

class SessionLogsPage extends StatelessWidget {
  const SessionLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> logs = [
      {'message': 'Lorem ipsum', 'time': '12:30'},
      {
        'message':
            'Lorem ipsum asdcaLorem ipsum asdcaLorem ipsum asdca Lorem ipsum asdcaLorem ipsum',
        'time': '13:20'
      },
      {'message': 'Lorem ipsum asdca Lorem', 'time': '13:20'},
      {
        'message':
            'Lorem ipsum asdcaLorem ipsum asdcaLorem ipsum asdca  Lorem ipsum asdcaLorem ipsum asdca Lorem',
        'time': '13:20'
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(title: 'Session'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 250, // sau ce înălțime vrei tu
            width: 340,
            child: CameraPreviewWidget(),
          ),
          AppSpaceses.verticalMedium,

          // Log-urile devin scrollabile
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              children: logs.map((log) {
                return _buildSimpleLogCard(log['message']!, log['time']!);
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBarActive(currentIndex: 2),
    );
  }

  Widget _buildSimpleLogCard(String message, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message,
              style: AppTextStyles.michroma.copyWith(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w900)),
          AppSpaceses.verticalTiny,
          Text(
            time,
            style: AppTextStyles.medium_12.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
