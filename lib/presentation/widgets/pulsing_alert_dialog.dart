import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PulsingAlertOverlay extends StatefulWidget {
  const PulsingAlertOverlay({super.key});

  @override
  State<PulsingAlertOverlay> createState() => _PulsingAlertOverlayState();
}

class _PulsingAlertOverlayState extends State<PulsingAlertOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0.3, // 30% opacity
      end: 0.6,   // 60% opacity when pulsing
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.red.withValues(alpha: 0.5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 100,
                    color: Colors.white,
                  ),
                  AppSpaceses.horizontalLarge,
                  Text(tr.warningAlert,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpaceses.horizontalMedium,
                  Text(tr.fatigueDetected,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
