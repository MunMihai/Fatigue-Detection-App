import 'dart:math' as math;

class AdjustmentUtils{
  static double calculateAdjustmentFactor({required int elapsedSeconds}) {
    const double L = 1.0; // limita maximă a scorului
    const double k = 0.005; // controlează panta de creștere
    const double x0 = 1800.0; // punctul de inflexiune (ex: 60 secunde)

    final double exponent = -k * (elapsedSeconds - x0);
    final double adjustment = L / (1 + math.exp(exponent));

    return adjustment.clamp(0.0, 1.0);
  }
}