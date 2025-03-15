import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  Future<PermissionStatus> requestCameraPermissionWithStatus() async {
    appLogger.i('[PermissionsService] Requesting camera permission...');

    final status = await Permission.camera.request();

    if (status.isGranted) {
      appLogger.i('[PermissionsService] Camera permission granted.');
    } else if (status.isPermanentlyDenied) {
      appLogger.e('[PermissionsService] Camera permission permanently denied.');
    } else {
      appLogger.w('[PermissionsService] Camera permission denied.');
    }

    return status;
  }
}

