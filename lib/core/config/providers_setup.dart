import 'package:driver_monitoring/core/services/permissions_service.dart';
import 'package:driver_monitoring/data/datasources/drift_sessin_report_local_datasource.dart';
import 'package:driver_monitoring/data/datasources/local/database_provider.dart';
import 'package:driver_monitoring/data/datasources/phone_camera_datasource.dart';
// import 'package:driver_monitoring/data/datasources/session_report_datasource.dart';
import 'package:driver_monitoring/data/repositories/camera_repository_impl.dart';
import 'package:driver_monitoring/data/repositories/session_report_repositiry_impl.dart';
import 'package:driver_monitoring/data/services/alert_service_impl.dart';
import 'package:driver_monitoring/data/services/flutter_ringtone_audio_service.dart';
import 'package:driver_monitoring/data/services/mlkit_face_detection_service.dart';
import 'package:driver_monitoring/domain/repositories/session_report_repository.dart';
import 'package:driver_monitoring/domain/services/alert_service.dart';
import 'package:driver_monitoring/domain/services/audio_service.dart';
import 'package:driver_monitoring/domain/services/face_detection_service.dart';
import 'package:driver_monitoring/domain/usecases/add_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/delete_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/get_reports_usecase.dart';
import 'package:driver_monitoring/domain/usecases/update_report_usecase.dart';
import 'package:driver_monitoring/presentation/providers/camera_provider.dart';
import 'package:driver_monitoring/presentation/providers/pause_provider.dart';
import 'package:driver_monitoring/presentation/providers/score_provider.dart';
import 'package:driver_monitoring/presentation/providers/session_manager.dart';
import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';
import 'package:driver_monitoring/presentation/providers/session_timer_provider.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppProvidersWrapper extends StatefulWidget {
  final Widget child;

  const AppProvidersWrapper({super.key, required this.child});

  @override
  State<AppProvidersWrapper> createState() => _AppProvidersWrapperState();
}

class _AppProvidersWrapperState extends State<AppProvidersWrapper> {
  late final SessionReportRepository _sessionReportRepository;
  late final CameraProvider _cameraProvider;
  late final AlertService _alertService;
  late final AudioService _audioService;

  @override
  void initState() {
    super.initState();
    _initDependencies();
  }

  void _initDependencies() {
    final db = DatabaseProvider().database;
    final reportDataSource = DriftSessionReportLocalDataSource(db);
    _sessionReportRepository = SessionReportRepositoryImpl(dataSource: reportDataSource);
    reportDataSource.deleteExpiredReports(DateTime.now());

    final cameraDataSource = PhoneCameraDataSource();
    final cameraRepo = CameraRepositoryImpl(cameraDataSource);
    _cameraProvider = CameraProvider(cameraRepo);

    _audioService = FlutterRingtoneAudioService();
    _alertService = AlertServiceImpl(audioService: _audioService);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()..loadSettings()),
        Provider<PermissionsService>(lazy: false, create: (_) => PermissionsService()),
        ChangeNotifierProvider<CameraProvider>.value(value: _cameraProvider),
        Provider<AudioService>.value(value: _audioService),
        Provider<AlertService>.value(value: _alertService),

        ProxyProvider<SettingsProvider, FaceDetectionService>(
          lazy: false,
          update: (_, settings, __) => MLKitFaceDetectionService(settings.faceDetectorMode),
        ),

        ChangeNotifierProxyProvider2<SettingsProvider, CameraProvider, SessionManager>(
          create: (context) => SessionManager(
            settingsProvider: context.read<SettingsProvider>(),
            cameraProvider: _cameraProvider,
            faceDetectionService: context.read<FaceDetectionService>(),
            sessionTimer: SessionTimer(),
            pauseManager: PauseManager(),
            alertService: _alertService,
          ),
          update: (context, _, __, sessionManager) {
            sessionManager!.updateFaceService(context.read<FaceDetectionService>());
            return sessionManager;
          },
        ),

        ChangeNotifierProvider(
          create: (context) => ScoreProvider(context.read<SessionManager>()),
        ),

        ChangeNotifierProxyProvider<SettingsProvider, SessionReportProvider>(
          create: (_) => SessionReportProvider(
            getReportsUseCase: GetReportsUseCase(_sessionReportRepository),
            addReportUseCase: AddReportUseCase(_sessionReportRepository),
            updateReportUseCase: UpdateReportUseCase(_sessionReportRepository),
            deleteReportUseCase: DeleteReportUseCase(_sessionReportRepository),
          ),
          update: (_, settingsProvider, reportProvider) {
            final isReportsEnabled = settingsProvider.isReportsSectionEnabled;
            final provider = reportProvider ?? SessionReportProvider(
              getReportsUseCase: GetReportsUseCase(_sessionReportRepository),
              addReportUseCase: AddReportUseCase(_sessionReportRepository),
              updateReportUseCase: UpdateReportUseCase(_sessionReportRepository),
              deleteReportUseCase: DeleteReportUseCase(_sessionReportRepository),
            );

            if (isReportsEnabled && !provider.hasFetchedReports) {
              provider.fetchReports();
            } else if (!isReportsEnabled) {
              provider.clearReports();
            }

            return provider;
          },
        ),
      ],
      child: widget.child,
    );
  }
}
