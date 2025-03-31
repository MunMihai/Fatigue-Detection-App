import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBarIDLE extends StatelessWidget {
  final int currentIndex;
  final Function(int index) onItemTapped;

  const BottomNavBarIDLE({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
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
            if (index == 1 && !isReportsEnabled) return;

            onItemTapped(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: tr.homeTab,
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
              label: isReportsEnabled ? tr.reportsTab : tr.enableInSettingsTab,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: tr.settingsTab,
            ),
          ],
        );
      },
    );
  }
}
