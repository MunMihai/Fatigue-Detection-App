import 'package:driver_monitoring/core/constants/app_gifs.dart';
import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppSpaceses.verticalLarge,
            Container(
              width: double.infinity, // Ocupă toată lățimea ecranului
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.black, // Culoarea borderului
                      width: 30, // Grosimea borderului sus și jos
                    ),
                  )
                  ),
              child: Image.asset(
                AppGIFs.splashGif,
                fit: BoxFit.cover,
                gaplessPlayback: true // Asigură că imaginea umple containerul
              ),
            ),
            AppSpaceses.verticalLarge,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Text(
                    'Start your journey',
                    style: AppTextStyles.h1,
                  ),
                  AppSpaceses.verticalLarge,
                  Text(
                    'To help you stay safe on the road, we\'ll monitor for signs of fatigue and offer a reminder to take a break if needed.',
                    style: AppTextStyles.regular_24,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            AppSpaceses.verticalExtraLarge,
            ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryButton,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryButton,
                    minimumSize: const Size(340, 56)),
                child: Text(
                  'Start navigation',
                  style: AppTextStyles.h3,
                )),
            AppSpaceses.verticalLarge,
            ElevatedButton(
                onPressed: () => context.go('/fags'),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryButton,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryButton,
                    minimumSize: const Size(244, 40)),
                child: Text(
                  'Check FAQs',
                  style: AppTextStyles.h3,
                ))
          ],
        ),
      ),
    );
  }
}
