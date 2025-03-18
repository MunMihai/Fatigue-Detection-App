import 'package:driver_monitoring/core/services/session_manager.dart';
import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:driver_monitoring/core/utils/show_confiramtion_dialog.dart';
import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BottomNavBarActive extends StatelessWidget {
  final int currentIndex;
  final Function(int index)? onItemTapped;

  const BottomNavBarActive({
    super.key,
    required this.currentIndex,
    this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final sessionManager = context.watch<SessionManager>();

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      selectedItemColor: Theme.of(context).colorScheme.activeIcon,
      unselectedItemColor: Theme.of(context).colorScheme.inactiveIcon,
      iconSize: 30,
      currentIndex: currentIndex,
      onTap: (index) async {
        if (index == currentIndex) return;

        if (index == 1) {
          final confirmed = await showConfirmationDialog(
            context: context,
            title: 'Stop Monitoring',
            confirmText: 'STOP',
            message:
                'Are you sure you want to stop monitoring? Stopping monitoring will interrupt all alerts and stop recording the current session.',
            showIcon: false,
          );

          if (confirmed) {
            if(!context.mounted) return;
            final sessionReportProvider = context.read<SessionReportProvider>();
            final finishedSession = await sessionManager.stopMonitoring();

            if (finishedSession != null) {
              await sessionReportProvider.addReport(finishedSession);
              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Session saved successfully!')),
              );

              context.go('/');
            } else {
              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No active session to stop!')),
              );
            }
          }

          return; 
        }

        if (onItemTapped != null) {
          onItemTapped!(index);
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.visibility_outlined),
          activeIcon: const Icon(Icons.visibility),
          label: 'Main',
        ),
        BottomNavigationBarItem(
          icon: Stack(alignment: Alignment.center, children: [
            Icon(
              Icons.power_settings_new,
              size: 40,
              color: const Color(0xFFF00004),
              shadows: [
                Shadow(
                  color: const Color(0xFFF00004),
                  offset: Offset(0, 0),
                  blurRadius: 100,
                ),
              ],
            ),
            Icon(
              Icons.power_settings_new,
              size: 46,
              color: const Color(0xFFF00004),
            )
          ]),
          label: 'Exit',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_applications_outlined),
          activeIcon: const Icon(Icons.settings_applications),
          label: 'Calibration',
        ),
      ],
    );
  }
}
