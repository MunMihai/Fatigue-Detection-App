import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:driver_monitoring/presentation/pages/camera_preview_view.dart';
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
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2);
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeSessionProvider = context.watch<ActiveSessionProvider>();
    
    final index = activeSessionProvider.selectedIndex;
    final pageIndex = index == 1 ? 2 : index;

    final List<Widget> pages = const [
      MainMonitoringView(),
      CameraPreviewView(),
    ];

    if (_pageController.hasClients && _pageController.page?.round() != index) {
      _pageController.jumpToPage(index);
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onUserInteraction,
      onPanDown: (_) => _onUserInteraction(),
      child: Scaffold(
        appBar: _showUIBars ? _buildAppBar(pageIndex) : null,
        body: PageView(
          controller: _pageController,
          children: pages,
          onPageChanged: (pageIndex) {
            activeSessionProvider.selectedIndex = pageIndex;
          },
        ),
        bottomNavigationBar: _showUIBars
            ? BottomNavBarActive(
                currentIndex: pageIndex,
              )
            : null,
      ),
    );
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

  PreferredSizeWidget? _buildAppBar(int index) {
    final tr = AppLocalizations.of(context)!;

    switch (index) {
      case 0:
        return CustomAppBar(title: tr.monitoringStatus);
      case 2:
        return CustomAppBar(title: tr.cameraPreview);
      default:
        return null;
    }
  }
}
