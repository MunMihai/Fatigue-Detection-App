import 'package:collection/collection.dart';
import 'package:driver_monitoring/core/utils/page_transitions.dart';
import 'package:driver_monitoring/presentation/pages/acticve_state_log_page.dart';
import 'package:driver_monitoring/presentation/pages/active_state_monitoring_page.dart';
import 'package:driver_monitoring/presentation/pages/all_session_reports_page.dart';
import 'package:driver_monitoring/presentation/pages/home_page.dart';
import 'package:driver_monitoring/presentation/pages/not_found_page.dart';
import 'package:driver_monitoring/presentation/pages/reports_page.dart';
import 'package:driver_monitoring/presentation/pages/report_detailed_page.dart';
import 'package:driver_monitoring/presentation/pages/settings_page.dart';
import 'package:driver_monitoring/presentation/pages/landing_page.dart';
import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static final GoRouter router =
      GoRouter(initialLocation: '/landingPage', routes: [
    GoRoute(
      path: '/landingPage',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/reports',
      builder: (context, state) => const ReportsPage(),
    ),
    GoRoute(
      path: '/allSessions',
      pageBuilder: (context, state) => fadeSlideTransition(
        child: const AllSessionRportsPage(),
        state: state,
      ),
    ),
    GoRoute(
      path: '/reports/session/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;

        final sessionReportProvider = context.read<SessionReportProvider>();

        final sessionReport = sessionReportProvider.reports.firstWhereOrNull(
          (s) => s.id == id,
        );
        if (sessionReport == null) {
          return fadeSlideTransition(
            child: NotFoundPage(message: 'Session report not found'),
            state: state,
          );
        }

        return fadeSlideTransition(
          child: ReportDetailedPage(sessionReport: sessionReport),
          state: state,
        );
      },
    ),
    GoRoute(
      path: '/activeMonitoring/main',
      builder: (context, state) => const ActiveMonitoringMainPage(),
    ),
    GoRoute(
      path: '/activeMonitoring/logs',
      builder: (context, state) => const SessionLogsPage(),
    ),
  ]);
}
