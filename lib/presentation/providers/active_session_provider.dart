import 'package:driver_monitoring/core/enum/alert_type.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:flutter/material.dart';
import 'package:driver_monitoring/core/services/session_manager.dart';
import 'package:driver_monitoring/core/enum/app_state.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/core/utils/show_confiramtion_dialog.dart';
import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';
import 'package:go_router/go_router.dart';

class ActiveSessionProvider extends ChangeNotifier {
  final SessionManager sessionManager;
  final SessionReportProvider sessionReportProvider;
  final BuildContext context;

  bool _hasSavedSession = false;

  int selectedIndex = 0;

  ActiveSessionProvider({
    required this.sessionManager,
    required this.sessionReportProvider,
    required this.context,
  }) {
    appLogger.i('[ActiveSessionProvider] CREATED');
    sessionManager.addListener(_handleSessionStateChange);
    sessionManager.onSessionTimeout = _onSessionTimeout;
  }

  @override
  void dispose() {
    appLogger.w('[ActiveSessionProvider] DESTROYED');
    sessionManager.removeListener(_handleSessionStateChange);
    sessionManager.onSessionTimeout = null;
    _hasSavedSession = false;
    super.dispose();
  }

  /// Select item logic (navigare între pagini)
  void onItemTapped(int index) {
    final appState = sessionManager.appState;

    if (index == 1) {
      _stopSessionFlow();
      return;
    }

    if (appState == AppState.active ||
        appState == AppState.paused ||
        appState == AppState.alertness) {
      selectedIndex = index;
      notifyListeners();
    } else {
      appLogger.w('No active session!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active session!')),
      );
    }
  }

  Future<void> _onSessionTimeout() async {
    if (!context.mounted) return;

    appLogger.i('[ActiveSessionProvider] Handling session timeout...');

    final shouldStop = await showConfirmationDialog(
      context: context,
      title: 'Break Time!',
      message:
          'The session countdown has finished. Do you want to stop monitoring?',
      confirmText: 'STOP',
      cancelText: 'CONTINUE',
      showIcon: true,
    );

    if (!context.mounted) return;

    if (shouldStop) {
      appLogger.i(
          '[ActiveSessionProvider] User chose to stop session after timeout.');

      /// Stop session flow complet (cu raport + navigare)
      _stopSessionFlow();
    } else {
      appLogger.i('[ActiveSessionProvider] User chose to continue session.');

      /// 🟢 Oprim alerta
      sessionManager.alertManager.stopAlert(type: AlertType.sessionExpired.name);

      /// 🟢 (Opțional) schimbi starea dacă era în alertness și nu mai e necesar
      if (sessionManager.appState == AppState.alertness) {
        sessionManager.resumeMonitoring(); // Dacă ai o funcție de resume
      }

      /// Sau, doar notifici că s-a oprit alerta
      notifyListeners();
    }
  }

  void _handleSessionStateChange() async {
    if (sessionManager.stopping && !_hasSavedSession) {
      appLogger.i(
          '[ActiveSessionProvider] Session stopping. Preparing to save session report...');

      final finishedSession = sessionManager.currentSession?.copyWith(
        durationMinutes: sessionManager.sessionTimer.elapsedTime.inMinutes,
        alerts: sessionManager.alertManager.alerts,
        averageSeverity: sessionManager.alertManager.averageSeverity,
      );

      await _saveSessionReport(finishedSession);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.go('/');
      });
    }
  }

  Future<void> _stopSessionFlow() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Stop Monitoring',
      confirmText: 'STOP',
      message:
          'Are you sure you want to stop monitoring? Stopping monitoring will interrupt all alerts and stop recording the current session.',
      showIcon: false,
    );

    if (!confirmed) {
      appLogger.i('[ActiveSessionProvider] Stop session canceled by user.');
      return;
    }

    _hasSavedSession = true;
    final finishedSession = await sessionManager.stopMonitoring();

    await _saveSessionReport(finishedSession);

    if (!context.mounted) return;
    context.go('/');
  }

  Future<bool> _saveSessionReport(SessionReport? finishedSession) async {
    if (finishedSession != null) {
      await sessionReportProvider.addReport(finishedSession);

      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session saved successfully!')),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active session to stop!')),
      );
      return false;
    }
  }
}
