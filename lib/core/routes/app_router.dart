import 'package:driver_monitoring/presentation/pages/home_page.dart';
import 'package:driver_monitoring/presentation/pages/settings_page.dart';
import 'package:driver_monitoring/presentation/pages/landing_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/landingPage',
    routes: [
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
    ]
  );
}