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
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2);
  }

  @override
  void dispose() {
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients &&
          _pageController.page?.round() != index) {
        _pageController.jumpToPage(index);
      }
    });

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: _toggleUIBars,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                _showUIBars ? _buildAppBar(pageIndex) : const SizedBox.shrink(),
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: pages,
          onPageChanged: (pageIndex) {
            activeSessionProvider.selectedIndex = pageIndex;
          },
        ),
        bottomNavigationBar: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showUIBars
              ? BottomNavBarActive(currentIndex: pageIndex)
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  void _toggleUIBars() {
    setState(() {
      _showUIBars = !_showUIBars;
    });
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
