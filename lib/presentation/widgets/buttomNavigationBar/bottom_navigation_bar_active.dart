import 'package:flutter/material.dart';
import 'package:driver_monitoring/presentation/providers/active_session_provider.dart';
import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:provider/provider.dart';

class BottomNavBarActive extends StatelessWidget {
  final int currentIndex;

  const BottomNavBarActive({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.read<ActiveSessionProvider>();

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      selectedItemColor: Theme.of(context).colorScheme.activeIcon,
      unselectedItemColor: Theme.of(context).colorScheme.inactiveIcon,
      iconSize: 30,
      currentIndex: currentIndex,
      onTap: sessionProvider.onItemTapped,
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
