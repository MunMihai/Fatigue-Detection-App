import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:driver_monitoring/core/constants/app_gifs.dart';
import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/services/permissions_service.dart';
import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            AppSpaceses.verticalLarge,
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.black,
                      width: 30,
                    ),
                  )),
              child: Image.asset(AppGIFs.splashGif,
                  fit: BoxFit.cover, gaplessPlayback: true),
            ),
            AppSpaceses.verticalLarge,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    tr.startYourJourney,
                    style: AppTextStyles.h1,
                  ),
                  AppSpaceses.verticalLarge,
                  Text(
                    tr.journeyDescription,
                    style: AppTextStyles.regular_24,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            AppSpaceses.verticalExtraLarge,
            FractionallySizedBox(
              widthFactor: 0.9,
              child: PrimaryButton(
                  title: tr.startNavigation,
                  onPressed: () async {
                    final permissionsService =
                        context.read<PermissionsService>();

                    final permissionStatus = await permissionsService
                        .requestCameraPermissionWithStatus();

                    if (!context.mounted) return;

                    switch (permissionStatus) {
                      case PermissionStatus.granted:
                        if (!context.mounted) return;
                        context.go('/');
                        break;

                      case PermissionStatus.permanentlyDenied:
                        final opened = await openAppSettings();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              opened
                                  ? tr.enableCameraInSettings
                                  : tr.couldNotOpenSettings,
                            ),
                          ),
                        );
                        break;

                      default:
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              tr.cameraPermissionRequired,
                            ),
                          ),
                        );
                    }
                  }),
            ),
            AppSpaceses.verticalLarge,
            FractionallySizedBox(
              widthFactor: 0.6,
              child: ElevatedButton(
                onPressed: () => context.push('/faqs'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryButton,
                  foregroundColor:
                      Theme.of(context).colorScheme.onSecondaryButton,
                  minimumSize: const Size(0, 40),
                ),
                child: Text(
                  tr.checkFaqs,
                  style: AppTextStyles.h3,
                ),
              ),
            ),
            AppSpaceses.verticalLarge
          ],
        ),
      ),
    );
  }
}
