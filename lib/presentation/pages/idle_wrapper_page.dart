import 'package:driver_monitoring/presentation/pages/home_view.dart';
import 'package:driver_monitoring/presentation/widgets/buttomNavigationBar/buttom_navigation_bar_idle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:driver_monitoring/presentation/providers/settings_provider.dart';

// Pagini de exemplu
import 'reports_view.dart';
import 'settings_view.dart';

class IdleWrapper extends StatefulWidget {
  const IdleWrapper({super.key});

  @override
  State<IdleWrapper> createState() => _IdleWrapperState();
}

class _IdleWrapperState extends State<IdleWrapper> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    final isReportsEnabled = settingsProvider.isReportsSectionEnabled;

    final List<Widget> pages = [
      const HomeView(),
      isReportsEnabled ? const ReportsView() : const SizedBox(),
      const SettingsView(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavBarIDLE(
        currentIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
