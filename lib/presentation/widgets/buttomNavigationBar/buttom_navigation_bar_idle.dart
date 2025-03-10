import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBarIDLE extends StatelessWidget {
  final int currentIndex;

  const BottomNavBarIDLE({
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
      onTap: (index) {
        if (index == currentIndex) return; // Dacă e deja selectat, nu face nimic

        switch (index) {
          case 0:
            context.push('/');
            break;
          case 1:
            context.push('/reports');
            break;
          case 2:
            context.push('/settings');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          activeIcon: Icon(Icons.bar_chart),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
