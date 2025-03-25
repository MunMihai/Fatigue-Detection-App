import 'dart:math' as math;

class AdjustmentUtils{
  static double calculateAdjustmentFactor({required int elapsedSeconds}) {
    const double L = 1.5;
    const double k = 0.005; 
    const double x0 = 900.0; 

    final double exponent = -k * (elapsedSeconds - x0);
    final double adjustment = L / (1 + math.exp(exponent));

    return adjustment.clamp(0.0, 1.0);
  }
}