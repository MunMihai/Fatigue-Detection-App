import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => context.go('/splashScreen'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryButton,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryButton,
              minimumSize: const Size(340, 56)),
          child: Text(
            'Start navigation',
            style: AppTextStyles.h3,
          )),
      ],
    )));
  }
}
