import 'package:driver_monitoring/core/services/face_detection_service.dart';
import 'package:driver_monitoring/presentation/providers/camera_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:driver_monitoring/core/services/alert_manager.dart';
import 'package:driver_monitoring/core/services/pause_manager.dart';
import 'package:driver_monitoring/core/services/permissions_service.dart';
import 'package:driver_monitoring/core/services/session_manager.dart';
import 'package:driver_monitoring/core/services/session_timer.dart';

import 'package:driver_monitoring/data/datasources/drift_sessin_report_local_datasource.dart';
import 'package:driver_monitoring/data/datasources/local/database_provider.dart';

import 'package:driver_monitoring/data/repositories/session_report_repositiry_impl.dart';
import 'package:driver_monitoring/domain/usecases/get_reports_usecase.dart';
import 'package:driver_monitoring/domain/usecases/add_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/update_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/delete_report_usecase.dart';

import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';
import 'package:driver_monitoring/presentation/providers/score_provider.dart';

class AppProvidersWrapper extends StatefulWidget {
  final Widget child;

  const AppProvidersWrapper({super.key, required this.child});

  @override
  State<AppProvidersWrapper> createState() => _AppProvidersWrapperState();
}

class _AppProvidersWrapperState extends State<AppProvidersWrapper> {
  @override
  Widget build(BuildContext context) {
    /// 🗄️ Inițializare DB și repository
    final db = DatabaseProvider().database;
    final reportDataSource = DriftSessionReportLocalDataSource(db);
    //final reportDataSource = MockSessionReportLocalDataSource(); // pentru teste / mock
    final sessionReportRepository =
        SessionReportRepositoryImpl(dataSource: reportDataSource);

    /// 🛠️ Inițializare use case-uri
    final getReportsUseCase = GetReportsUseCase(sessionReportRepository);
    final addReportUseCase = AddReportUseCase(sessionReportRepository);
    final updateReportUseCase = UpdateReportUseCase(sessionReportRepository);
    final deleteReportUseCase = DeleteReportUseCase(sessionReportRepository);

    return MultiProvider(
      providers: [
        /// 🔧 Settings (preferințe salvate: ore, minute, retention)
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider()..loadSettings(),
        ),

        /// 🔧 ScoreProvider (pentru UI feedback de scor, probabil la analiza de oboseală)
        ChangeNotifierProvider(create: (_) => ScoreProvider()),

        /// 🛡️ PermissionsService (permisiuni runtime)
        Provider<PermissionsService>(
          lazy: false,
          create: (_) => PermissionsService(),
        ),

        ChangeNotifierProvider<CameraProvider>(create: (_) => CameraProvider()),
        ChangeNotifierProvider<FaceDetectionService>(create: (_) => FaceDetectionService()),

        // SessionManager controlează starea + lifecycle cameră
        ChangeNotifierProxyProvider2<SettingsProvider, CameraProvider, SessionManager>(
          create: (context) {
            final settingsProvider = context.read<SettingsProvider>();
            final cameraProvider = context.read<CameraProvider>();
            final faceDetectionService = context.read<FaceDetectionService>();
            final sessionTimer = SessionTimer();
            final pauseManager = PauseManager();
            final alertManager = AlertManager();

            return SessionManager(
              settingsProvider: settingsProvider,
              cameraProvider: cameraProvider,
              faceDetectionService: faceDetectionService,
              sessionTimer: sessionTimer,
              pauseManager: pauseManager,
              alertManager: alertManager,
            );
          },
          update: (_, settingsProvider, cameraProvider, sessionManager) => sessionManager!,
        ),

        /// 📝 SessionReportProvider (pentru listarea, salvarea și gestionarea rapoartelor)
        ChangeNotifierProxyProvider<SettingsProvider, SessionReportProvider>(
          create: (_) => SessionReportProvider(
            getReportsUseCase: getReportsUseCase,
            addReportUseCase: addReportUseCase,
            updateReportUseCase: updateReportUseCase,
            deleteReportUseCase: deleteReportUseCase,
          ),
          update: (_, settingsProvider, reportProvider) {
            final isEnabled = settingsProvider.isReportsSectionEnabled;

            final nonNullReportProvider = reportProvider ??
                SessionReportProvider(
                  getReportsUseCase: getReportsUseCase,
                  addReportUseCase: addReportUseCase,
                  updateReportUseCase: updateReportUseCase,
                  deleteReportUseCase: deleteReportUseCase,
                );

            if (isEnabled && !nonNullReportProvider.hasFetchedReports) {
              nonNullReportProvider.fetchReports();
            }

            return nonNullReportProvider;
          },
        ),
      ],
      child: widget.child,
    );
  }
}
