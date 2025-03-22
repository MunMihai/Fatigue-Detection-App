import 'package:driver_monitoring/presentation/pages/home_view.dart';
import 'package:driver_monitoring/presentation/pages/reports_view.dart';
import 'package:driver_monitoring/presentation/pages/settings_view.dart';
import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';
import 'package:driver_monitoring/presentation/widgets/buttomNavigationBar/buttom_navigation_bar_idle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IdleWrapper extends StatefulWidget {
  const IdleWrapper({super.key});

  @override
  State<IdleWrapper> createState() => _IdleWrapperState();
}

class _IdleWrapperState extends State<IdleWrapper> {
  int _selectedIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      context.read<SessionReportProvider>().refreshReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final isReportsEnabled = settingsProvider.isReportsSectionEnabled;

    final List<Widget> pages = [
      HomeView(onChangeTab: _onTabChanged),
      isReportsEnabled ? const ReportsView() : const SizedBox(),
      const SettingsView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavBarIDLE(
        currentIndex: _selectedIndex,
        onItemTapped: (index) {
          if (index == 1 && !isReportsEnabled) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reports section is disabled!')),
            );
            return;
          }
          _onTabChanged(index);
        },
      ),
    );
  }
}
