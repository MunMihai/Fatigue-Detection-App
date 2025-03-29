import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

abstract class FaceDetectionService {
  bool get closedEyesDetected;
  bool get yawningDetected;
  DateTime get lastFaceDetectedTime;
  CustomPaint? get customPaint;
  String? get detectionText;

  void reset(int sensitivity);
  Future<void> processImage(InputImage inputImage);
}
