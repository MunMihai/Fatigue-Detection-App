import 'package:driver_monitoring/core/constants/app_gifs.dart';
import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
// import 'package:driver_monitoring/core/services/camera_manager.dart';
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
    return Scaffold(
      body: Center(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
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
                  )),
              child: Image.asset(AppGIFs.splashGif,
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
            FractionallySizedBox(
              widthFactor: 0.9,
              child: PrimaryButton(
                  title: 'Start navigation',
                  onPressed: () async {
                    final permissionsService = context.read<PermissionsService>();
                    // final cameraManager = context.read<CameraManager>();
              
                    final permissionStatus = await permissionsService
                        .requestCameraPermissionWithStatus();
              
                    if (!context.mounted) return;
              
                    switch (permissionStatus) {
                      case PermissionStatus.granted:
                        // await cameraManager.initializeCamera();
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
                                  ? 'Please enable camera permission in settings.'
                                  : 'Could not open app settings.',
                            ),
                          ),
                        );
                        break;
              
                      default:
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Camera permission is required to proceed.'),
                          ),
                        );
                    }
                  }),
            ),
            AppSpaceses.verticalLarge,
            FractionallySizedBox(
              widthFactor: 0.6, // 80% din ecran
              child: ElevatedButton(
                onPressed: () => context.go('/fags'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryButton,
                  foregroundColor:
                      Theme.of(context).colorScheme.onSecondaryButton,
                  minimumSize: const Size(0, 40), // sau Size.zero
                ),
                child: Text(
                  'Check FAQs',
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
