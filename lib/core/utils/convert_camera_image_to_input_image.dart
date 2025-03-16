import 'package:camera/camera.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

Future<InputImage> convertCameraImageToInputImage(
  CameraImage image,
  CameraDescription cameraDescription,
) async {
  final WriteBuffer allBytes = WriteBuffer();
  for (Plane plane in image.planes) {
    allBytes.putUint8List(plane.bytes);
  }

  final bytes = allBytes.done().buffer.asUint8List();

  final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

  final rotation = InputImageRotationValue.fromRawValue(
        cameraDescription.sensorOrientation,
      ) ??
      InputImageRotation.rotation0deg;

  final format = InputImageFormat.nv21;

  final inputImageMetadata = InputImageMetadata(
    size: imageSize,
    rotation: rotation,
    format: format,
    bytesPerRow: image.planes.first.bytesPerRow,
  );
appLogger.t('Rotation: $rotation, Format: $format, BytesPerRow: ${image.planes.first.bytesPerRow}');


  return InputImage.fromBytes(
    bytes: bytes,
    metadata: inputImageMetadata,
  );
}
