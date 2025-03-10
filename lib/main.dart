import 'package:driver_monitoring/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_color_scheme.dart';
import 'core/routes/app_router.dart';

void main() async{
 WidgetsFlutterBinding.ensureInitialized();

  // ✅ Blochează aplicația pe Portrait Mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Numai portret normal
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsController()..loadSettings(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Monitoring App',
      theme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return SafeArea( // Adaugă automat padding pentru status bar
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}

