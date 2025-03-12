import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';

class BottomNavBarIDLE extends StatelessWidget {
  final int currentIndex;

  const BottomNavBarIDLE({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, _) {
        final isReportsEnabled = settingsProvider.isReportsSectionEnabled;

        return BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Theme.of(context).colorScheme.activeIcon,
          unselectedItemColor: Theme.of(context).colorScheme.inactiveIcon,
          iconSize: 30,
          currentIndex: currentIndex,
          onTap: (index) {
            if (index == currentIndex) return;

            switch (index) {
              case 0:
                context.go('/');
                break;

              case 1:
                if (!isReportsEnabled) return; // Blocăm tap-ul
                context.push('/reports');
                break;

              case 2:
                context.push('/settings');
                break;
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                isReportsEnabled
                    ? Icons.bar_chart_outlined
                    : Icons.lock_outline,
                color: isReportsEnabled ? null : Colors.grey.shade600,
              ),
              activeIcon: Icon(
                isReportsEnabled ? Icons.bar_chart : Icons.lock,
                color: isReportsEnabled ? null : Colors.grey.shade600,
              ),
              label: isReportsEnabled
                  ? 'Reports'
                  : 'Enable in Settings', // ✨ mai informativ
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        );
      },
    );
  }
}
