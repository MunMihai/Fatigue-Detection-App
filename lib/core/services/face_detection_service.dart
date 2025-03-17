// import 'package:driver_monitoring/core/utils/face_detector_painter.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:flutter/material.dart';

// class FaceDetectionService {
//   final FaceDetector _faceDetector;

//   FaceDetectionService()
//       : _faceDetector = FaceDetector(
//           options: FaceDetectorOptions(
//             enableLandmarks: true,
//             enableContours: true,
//           ),
//         );

//   Future<CustomPaint?> processFrame(InputImage image, Size imageSize, int rotation) async {
//     final faces = await _faceDetector.processImage(image);

//     if (faces.isEmpty) {
//       return null; // Nimic de desenat
//     }

//     return CustomPaint(
//       painter: FaceDetectorPainter(faces, imageSize, rotation, ),
//     );
//   }

//   Future<void> dispose() async {
//     await _faceDetector.close();
//   }
// }
