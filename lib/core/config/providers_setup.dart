import 'package:driver_monitoring/core/services/face_detection_service.dart';
import 'package:driver_monitoring/data/datasources/session_report_datasource.dart';
import 'package:driver_monitoring/domain/repositories/session_report_repository.dart';
import 'package:driver_monitoring/presentation/providers/camera_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:driver_monitoring/core/services/alert_service.dart';
import 'package:driver_monitoring/presentation/providers/pause_provider.dart';
import 'package:driver_monitoring/core/services/permissions_service.dart';
import 'package:driver_monitoring/presentation/providers/session_manager.dart';
import 'package:driver_monitoring/presentation/providers/session_timer_provider.dart';

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
  late final SessionReportDataSource _reportDataSource;
  late final SessionReportRepository _sessionReportRepository;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _deleteExpiredReports();
  }

  void _initDatabase() {
    final db = DatabaseProvider().database;
    _reportDataSource = DriftSessionReportLocalDataSource(db);
    _sessionReportRepository =
        SessionReportRepositoryImpl(dataSource: _reportDataSource);
  }

  Future<void> _deleteExpiredReports() async {
    await _reportDataSource.deleteExpiredReports(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final getReportsUseCase = GetReportsUseCase(_sessionReportRepository);
    final addReportUseCase = AddReportUseCase(_sessionReportRepository);
    final updateReportUseCase = UpdateReportUseCase(_sessionReportRepository);
    final deleteReportUseCase = DeleteReportUseCase(_sessionReportRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider()..loadSettings(),
        ),
        Provider<PermissionsService>(
          lazy: false,
          create: (_) => PermissionsService(),
        ),
        ChangeNotifierProvider(create: (_) => CameraProvider()),
        ChangeNotifierProxyProvider2<SettingsProvider, CameraProvider,
            SessionManager>(
          create: (context) {
            final settings = context.read<SettingsProvider>();
            final camera = context.read<CameraProvider>();

            return SessionManager(
              settingsProvider: settings,
              cameraProvider: camera,
              faceDetectionService: FaceDetectionService(),
              sessionTimer: SessionTimer(),
              pauseManager: PauseManager(),
              alertService: AlertService(),
            );
          },
          update: (_, __, ___, sessionManager) => sessionManager!,
        ),
        ChangeNotifierProvider<ScoreProvider>(
          create: (context) => ScoreProvider(context.read<SessionManager>()),
        ),
        ChangeNotifierProxyProvider<SettingsProvider, SessionReportProvider>(
          create: (_) => SessionReportProvider(
            getReportsUseCase: getReportsUseCase,
            addReportUseCase: addReportUseCase,
            updateReportUseCase: updateReportUseCase,
            deleteReportUseCase: deleteReportUseCase,
          ),
          update: (_, settingsProvider, reportProvider) {
            final isReportsEnabled = settingsProvider.isReportsSectionEnabled;

            final reports = reportProvider ??
                SessionReportProvider(
                  getReportsUseCase: getReportsUseCase,
                  addReportUseCase: addReportUseCase,
                  updateReportUseCase: updateReportUseCase,
                  deleteReportUseCase: deleteReportUseCase,
                );

            if (isReportsEnabled && !reports.hasFetchedReports) {
              reports.fetchReports();
            } else if (!isReportsEnabled) {
              reports.clearReports();
            }

            return reports;
          },
        ),
      ],
      child: widget.child,
    );
  }
}
