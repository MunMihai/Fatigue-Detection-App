import 'package:driver_monitoring/core/services/alert_manager.dart';
import 'package:driver_monitoring/core/services/pause_manager.dart';
import 'package:driver_monitoring/core/services/session_manager.dart';
import 'package:driver_monitoring/core/services/session_timer.dart';
import 'package:driver_monitoring/data/datasources/drift_sessin_report_local_datasource.dart';
import 'package:driver_monitoring/data/datasources/local/database_provider.dart';
import 'package:driver_monitoring/presentation/providers/score_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:driver_monitoring/data/repositories/session_report_repositiry_impl.dart';
import 'package:driver_monitoring/domain/usecases/get_reports_usecase.dart';
import 'package:driver_monitoring/domain/usecases/add_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/update_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/delete_report_usecase.dart';

import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';

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
    //final reportDataSource = MockSessionReportLocalDataSource();    //MockDatasource
    final sessionReportRepository =
        SessionReportRepositoryImpl(dataSource: reportDataSource);

    /// 🛠️ Inițializare use case-uri
    final getReportsUseCase = GetReportsUseCase(sessionReportRepository);
    final addReportUseCase = AddReportUseCase(sessionReportRepository);
    final updateReportUseCase = UpdateReportUseCase(sessionReportRepository);
    final deleteReportUseCase = DeleteReportUseCase(sessionReportRepository);

    return MultiProvider(
      providers: [
        /// ✅ Settings Provider (este important să fie PRIMUL)
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider()..loadSettings(),
        ),

        /// ✅ Score Provider (fără dependențe)
        ChangeNotifierProvider(create: (_) => ScoreProvider()),

        ChangeNotifierProxyProvider<SettingsProvider, SessionManager>(
          create: (context) {
            final settingsProvider = context.read<SettingsProvider>();

            // ⚙️ Inițializăm componentele pe care SessionManager le orchestrează
            final sessionTimer = SessionTimer();
            final pauseManager = PauseManager();
            final alertManager = AlertManager();

            return SessionManager(
              settingsProvider: settingsProvider,
              sessionTimer: sessionTimer,
              pauseManager: pauseManager,
              alertManager: alertManager,
            );
          },

          // update poate fi opțional în cazul tău dacă nu vrei să reactivezi SessionManager la schimbarea setărilor.
          update: (_, settingsProvider, sessionManager) {
            // Dacă SessionManager nu se schimbă pe parcurs, îl returnezi pur și simplu:
            return sessionManager!;
          },
        ),

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

      /// 📦 Aici bagi aplicația ta (sau widget-ul copil)
      child: widget.child,
    );
  }
}
