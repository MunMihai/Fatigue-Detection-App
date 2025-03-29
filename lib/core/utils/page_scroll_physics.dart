import 'package:flutter/material.dart';
 
class CustomPageScrollPhysics extends ScrollPhysics {
  const CustomPageScrollPhysics({super.parent});

  @override
  CustomPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get dragStartDistanceMotionThreshold => 3.5;

  @override
  double get minFlingDistance => 10.0;

  @override
  double get minFlingVelocity => 50.0;

  @override
  double get maxFlingVelocity => 2000.0;

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final page = position.pixels / position.viewportDimension;
    final currentPage = position.pixels ~/ position.viewportDimension;

    final threshold = 0.2;

    if ((page - currentPage).abs() > threshold || velocity.abs() > minFlingVelocity) {
      return super.createBallisticSimulation(position, velocity);
    }

    return null;
  }
}
