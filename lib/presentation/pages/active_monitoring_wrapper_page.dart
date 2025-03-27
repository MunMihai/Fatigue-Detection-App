import 'dart:async';

import 'package:driver_monitoring/presentation/pages/camera_calibration_view.dart';
import 'package:driver_monitoring/presentation/pages/main_monitoring_view.dart';
import 'package:driver_monitoring/presentation/providers/active_session_provider.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:driver_monitoring/presentation/widgets/buttomNavigationBar/bottom_navigation_bar_active.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveMonitoringWrapperPage extends StatefulWidget {
  const ActiveMonitoringWrapperPage({super.key});

  @override
  State<ActiveMonitoringWrapperPage> createState() =>
      _ActiveMonitoringWrapperPageState();
}

class _ActiveMonitoringWrapperPageState
    extends State<ActiveMonitoringWrapperPage> {
  bool _showUIBars = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() => _showUIBars = false);
      }
    });
  }

  void _onUserInteraction() {
    if (!_showUIBars) {
      setState(() => _showUIBars = true);
    }
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeSessionProvider = context.watch<ActiveSessionProvider>();
    final index = activeSessionProvider.selectedIndex;

    final List<Widget> pages = const [
      MainMonitoringView(),
      SizedBox(),
      CameraCalibrationView(),
    ];

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onUserInteraction,
      onPanDown: (_) => _onUserInteraction(),
      child: Scaffold(
        appBar: _showUIBars ? _buildAppBar(index) : null,
        body: pages[index],
        bottomNavigationBar:
            _showUIBars ? BottomNavBarActive(currentIndex: index) : null,
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(int index) {
    switch (index) {
      case 0:
        return CustomAppBar(title: 'Monitoring Status');
      case 2:
        return CustomAppBar(title: 'Camera Preview');
      default:
        return null;
    }
  }
}
