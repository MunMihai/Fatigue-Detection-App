import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/config/providers_setup.dart'; 
import 'core/constants/app_color_scheme.dart';
import 'core/routes/app_router.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    const AppProvidersWrapper(
      child: MyApp(),
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
      builder: (context, child) => SafeArea(child: child ?? const SizedBox()),
    );
  }
}
