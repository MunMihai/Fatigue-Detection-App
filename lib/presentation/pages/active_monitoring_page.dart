import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_monitoring/presentation/pages/main_monitoring_view.dart';
import 'package:driver_monitoring/presentation/pages/camera_calibration_view.dart';
import 'package:driver_monitoring/presentation/widgets/buttomNavigationBar/bottom_navigation_bar_active.dart';
import 'package:driver_monitoring/presentation/providers/active_session_provider.dart';

class ActiveMonitoringWrapperPage extends StatelessWidget {
  const ActiveMonitoringWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final activeSessionProvider = context.watch<ActiveSessionProvider>();

    final List<Widget> pages = const [
      MainMonitoringView(),
      SizedBox(), // Index 1 (Exit) - not used as a page, handled as action
      CameraCalibrationView(),
    ];

    return Scaffold(
      body: pages[activeSessionProvider.selectedIndex],
      bottomNavigationBar: BottomNavBarActive(
        currentIndex: activeSessionProvider.selectedIndex,
      ),
    );
  }
}
