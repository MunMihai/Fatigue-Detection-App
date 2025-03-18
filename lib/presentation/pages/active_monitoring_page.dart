import 'package:driver_monitoring/presentation/pages/main_monitoring_view.dart';
import 'package:driver_monitoring/presentation/pages/camera_calibration_view.dart';
import 'package:driver_monitoring/presentation/widgets/buttomNavigationBar/bottom_navigation_bar_active.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_monitoring/core/enum/app_state.dart';
import 'package:driver_monitoring/core/services/session_manager.dart';

class ActiveMonitoringWrapperPage extends StatefulWidget {
  const ActiveMonitoringWrapperPage({super.key});

  @override
  State<ActiveMonitoringWrapperPage> createState() =>
      _ActiveMonitoringWrapperState();
}

class _ActiveMonitoringWrapperState extends State<ActiveMonitoringWrapperPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    MainMonitoringView(),
    SizedBox(),
    CameraCalibrationView(),
  ];

  void _onItemTapped(int index, SessionManager sessionManager) async {
    final appState = sessionManager.appState;

    if (index == 1) {
      return;
    }

    if (appState == AppState.active ||
        appState == AppState.paused ||
        appState == AppState.alertness) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active session!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionManager = context.watch<SessionManager>();

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBarActive(
        currentIndex: _selectedIndex,
        onItemTapped: (index) => _onItemTapped(index, sessionManager),
      ),
    );
  }
}
