import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            context.go('/activeMonitoring/main');
            break;

          case 1:
            context.go('/');
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
