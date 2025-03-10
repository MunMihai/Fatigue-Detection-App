import 'package:driver_monitoring/presentation/pages/home_screen.dart';
import 'package:driver_monitoring/presentation/pages/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splashScreen',
    routes: [
      GoRoute(
        path: '/splashScreen',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
    ]
  );
}