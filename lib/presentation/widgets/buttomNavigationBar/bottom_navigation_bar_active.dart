import 'package:driver_monitoring/core/services/session_manager.dart';
import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:driver_monitoring/core/utils/show_confiramtion_dialog.dart';
import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BottomNavBarActive extends StatelessWidget {
  final int currentIndex;

  const BottomNavBarActive({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      selectedItemColor: Theme.of(context).colorScheme.activeIcon,
      unselectedItemColor: Theme.of(context).colorScheme.inactiveIcon,
      iconSize: 30,
      currentIndex: currentIndex,
      onTap: (index) async {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            context.go('/activeMonitoring/main');
            break;

          case 1:
            final sessionManager = context.read<SessionManager>();
            final sessionReportProvider = context.read<SessionReportProvider>();

            // Confirm the action before stopping the session
            final confirmed = await showConfirmationDialog(
              context: context,
              title: 'Stop Monitoring',
              confirmText: 'STOP',
              message: 'Are you sure you want to stop monitoring? Stopping monitoring will interrupt all alerts and stop recording the current session.',
              showIcon: false
            );

            if (confirmed) {
              final finishedSession = sessionManager.stopSession();

              if (finishedSession != null) {
                await sessionReportProvider.addReport(finishedSession);

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Session saved successfully!')),
                );

                // Navigate to the home page after session is saved
                context.go('/');
              } else {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No active session to stop!')),
                );
              }
            }
            break;

          case 2:
            context.go('/activeMonitoring/logs');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.visibility),
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
          icon: Icon(Icons.info_outline_rounded),
          label: 'Info',
        ),
      ],
    );
  }
}
